# frozen_string_literal: true

# Send email to client sent survey invitees
class ClientSentSurveyMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper
  layout 'client_sent_survey_mailer'

  def email_survey_invite(client_sent_survey_invitation)
    load_survey_invite_variables(client_sent_survey_invitation)
  end

  private

  def load_survey_invite_variables(client_sent_survey_invitation)
    @client_sent_survey_invitation = client_sent_survey_invitation
    @onramp = @client_sent_survey_invitation.onramp
    @client_sent_survey = @onramp.survey.client_sent_survey
    @incentive = format_currency_with_zeroes(@client_sent_survey.incentive.to_f) if @client_sent_survey.incentive.present?
    @employee = @client_sent_survey.employee

    mail(
      to: @client_sent_survey_invitation.email,
      from: "Op4G <#{@employee.email}>",
      subject: @client_sent_survey.email_subject
    )
  end

  def format_currency_with_zeroes(value)
    return '?' if value.blank?

    number_to_currency(value)
  end
end
