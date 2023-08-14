# frozen_string_literal: true

class Survey::FillsController < Survey::BaseController
  include SurveyResponseValidation

  before_action :load_and_validate_onboarding_record, only: :show

  def show; end
end
