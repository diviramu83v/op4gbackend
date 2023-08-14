# frozen_string_literal: true

# The job that sends out survey invitations. These jobs run in their own queue.
class ReminderDeliveryJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :invitations

  # rubocop:disable Metrics/AbcSize
  def perform(invitation, current_employee)
    return if invitation.reminded?
    return if invitation.panelist.inactive?

    mailer = MadMimiMailer.instance

    options = build_email_options(invitation)
    options = options.merge(recipients: current_employee.email) unless mailer.allow_real_emails?
    body = build_email_body(invitation)

    result = mailer.send(options, body)

    return unless mailer.successful?(result)

    invitation.reminded!

    invitation.batch.update!(reminders_finished_at: Time.now.utc) if invitation.batch.remindable_invitations.empty?
  end
  # rubocop:enable Metrics/AbcSize

  private

  def build_email_options(invitation)
    {
      from: 'support@op4g.com',
      recipients: invitation.panelist.email,
      track_links: false,
      promotion_name: 'platform_reminder_2020_07',
      subject: "Survey reminder: #{invitation.batch.email_subject}"
    }
  end

  def build_email_body(invitation)
    {
      title: invitation.batch.email_subject,
      payout: ApplicationController.helpers.format_currency(invitation.batch.incentive),
      first_name: invitation.panelist.first_name,
      time_to_complete: invitation.survey.loi,
      description: "#{invitation.batch.description}<br/><br/>#{invitation.project.email_template}",
      survey_link: invitation_url(invitation.token)
    }
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
