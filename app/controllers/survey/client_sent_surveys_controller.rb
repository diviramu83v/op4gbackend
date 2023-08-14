# frozen_string_literal: true

class Survey::ClientSentSurveysController < Survey::BaseController
  def show
    @onramp = Onramp.find_by(token: params[:token])
    redirect_to survey_error_url if @onramp.nil? || @onramp.survey.nil?
  end
end
