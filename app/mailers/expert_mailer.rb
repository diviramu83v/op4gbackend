# frozen_string_literal: true

# Send email to experts
class ExpertMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper
  layout 'expert_recruit_mailer'

  def email_survey_invite(expert_recruit)
    load_survey_invite_variables(expert_recruit)
  end

  def email_survey_invite_reminder(expert_recruit)
    load_survey_invite_variables(expert_recruit)
  end

  private

  def load_survey_invite_variables(expert_recruit) # rubocop:disable Metrics/AbcSize
    @expert_recruit = expert_recruit
    @onramp = @expert_recruit.survey.onramps.expert_recruit.first
    @batch = @expert_recruit.expert_recruit_batch
    @incentive = format_currency_with_zeroes(@batch.incentive.to_f) if @batch.incentive.present?
    @employee = @batch.employee

    mail(
      to: @expert_recruit.email,
      from: @batch.client_name.present? ? "#{@batch.client_name} <#{@batch.from_email}>" : "Op4G <#{@employee.email}>",
      subject: @batch.email_subject
    )
  end

  def format_currency_with_zeroes(value)
    return '?' if value.blank?

    number_to_currency(value)
  end
end
