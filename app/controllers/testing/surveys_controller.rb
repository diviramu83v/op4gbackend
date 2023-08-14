# frozen_string_literal: true

class Testing::SurveysController < Testing::BaseController
  def show
    @survey = Survey.find_by(token: params[:token])
    return redirect_back fallback_location: projects_url if @survey.blank?

    @onboarding = Onboarding.find_by(token: params[:uid])
    return redirect_back fallback_location: projects_url if @onboarding.blank?

    @project = @survey.project if @survey.present?
  end
end
