# frozen_string_literal: true

class Employee::CintCountryOptionsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def create
    @cint_survey = CintSurvey.find(params[:cint_survey_id]) if params[:cint_survey_id]
    @options = CintApi.new.country_demo_options(country_id: params[:country_id].to_i) if params[:country_id].present?
    @url = params[:url]
    render 'create'
  end
end
