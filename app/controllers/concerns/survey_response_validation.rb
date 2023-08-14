# frozen_string_literal: true

module SurveyResponseValidation
  include ActiveSupport::Concern

  private

  def load_and_validate_onboarding_record
    @onboarding = Onboarding.find_by(response_token: params[:token])

    return redirect_to survey_error_url if @onboarding.nil?
    return redirect_to survey_error_url if @onboarding.already_loaded_response_page?

    @onboarding.record_response_token_usage
  end
end
