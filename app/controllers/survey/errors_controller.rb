# frozen_string_literal: true

class Survey::ErrorsController < Survey::BaseController
  def show
    @onboarding = Onboarding.find_by(error_token: params[:token])
  end
end
