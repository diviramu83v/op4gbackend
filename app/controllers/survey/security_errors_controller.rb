# frozen_string_literal: true

class Survey::SecurityErrorsController < Survey::BaseController
  def show
    @onboarding = Onboarding.find(params[:onboarding_id])
  end
end
