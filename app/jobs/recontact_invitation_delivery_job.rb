# frozen_string_literal: true

# The job that sends out recontact invitations.
class RecontactInvitationDeliveryJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :invitations

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  def perform(invitation, current_employee)
    return if invitation.sent?
    return if invitation.original_onboarding.panelist&.inactive?
    return if invitation.original_onboarding.panelist&.birthdate_error_exists?

    mailer = MadMimiMailer.instance

    options = build_email_options(invitation)
    options = options.merge(recipients: current_employee.email) unless mailer.allow_real_emails?
    body = build_email_body(invitation)

    result = mailer.send(options, body)

    raise "invitation #{invitation.id}: API call unsuccessful: #{result}" unless mailer.successful?(result)

    invitation.sent!
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

  private

  def build_email_options(invitation)
    {
      from: 'support@op4g.com',
      recipients: invitation.original_onboarding.find_email_address,
      track_links: false,
      promotion_name: promotion(invitation),
      subject: "Follow Up survey available: #{invitation.recontact_invitation_batch.subject} (##{invitation.survey.project.id})"
    }
  end

  def build_email_body(invitation)
    {
      title: invitation.recontact_invitation_batch.subject,
      payout: ApplicationController.helpers.format_currency(invitation.recontact_invitation_batch.incentive),
      time_to_complete: invitation.survey.loi,
      description: "#{invitation.recontact_invitation_batch.email_body}<br/>",
      survey_link: survey_recontact_invitation_url(invitation.token)
    }
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def promotion(invitation)
    invitation.original_onboarding.vendor? ? 'recontact_vendor_invitation_2021_02' : 'recontact_panelist_invitation_2021_02'
  end
end
