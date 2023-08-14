# frozen_string_literal: true

# The job that sends out survey invitations. These jobs run in same queue as customer invitations.
class InvitationDeliveryJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :invitations

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def perform(invitation, current_employee)
    return if invitation.ever_sent?
    return if invitation.panelist.inactive?
    return if invitation.panelist.birthdate_error_exists?
    return if invitation.panelist.email_invalid?
    return if invitation.panelist.unsubscribed?

    raise "invitation #{invitation.id}: missing survey loi" if invitation.survey.loi.nil?
    raise "invitation #{invitation.id}: missing sample batch incentive" if invitation.batch.incentive.nil?

    mailer = MadMimiMailer.instance

    options = build_email_options(invitation)
    options = options.merge(recipients: current_employee.email) unless mailer.allow_real_emails?
    body = build_email_body(invitation)

    result = mailer.send(options, body)

    raise "invitation #{invitation.id}: API call unsuccessful: #{result}" unless mailer.successful?(result)

    return if result == "The recipient #{invitation.panelist.email} does not contain a valid email address."

    invitation.sent!

    @batch = invitation.batch

    html = ApplicationController.render(
      partial: 'employee/sample_batches/invitation_groups',
      locals: { batch: @batch }
    )

    BatchInvitationsChannel.broadcast_to(@batch, html)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  private

  def build_email_options(invitation)
    {
      from: 'support@op4g.com',
      recipients: invitation.panelist.email,
      track_links: false,
      promotion_name: 'platform_invitation_2022_05',
      subject: "New survey available: #{invitation.batch.email_subject} (##{invitation.project.id})"
    }
  end

  # rubocop:disable Metrics/AbcSize
  def build_email_body(invitation)
    {
      title: invitation.batch.email_subject,
      payout: ApplicationController.helpers.format_currency(invitation.batch.incentive),
      first_name: invitation.panelist.first_name,
      email: invitation.panelist.email,
      time_to_complete: invitation.survey.loi,
      description: "#{invitation.batch.description}<br/><br/>#{invitation.project.email_template}",
      unsubscribe_link: unsubscribe_url(email: invitation.panelist.email, token: invitation.token),
      survey_link: invitation_url(invitation.token)
    }
  end
  # rubocop:enable Metrics/AbcSize

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
