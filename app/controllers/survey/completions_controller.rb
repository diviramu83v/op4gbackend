# frozen_string_literal: true

class Survey::CompletionsController < Survey::BaseController
  include SurveyResponseValidation

  before_action :load_and_validate_onboarding_record, only: :show

  def show
    @completion_token = @onboarding.response_token

    return render if @onboarding.fraud_detected?
    return render if @onboarding.blocked_ip_address?
  end
end
