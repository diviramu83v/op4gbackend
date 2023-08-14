# frozen_string_literal: true

class Employee::CintSurveyActivationsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def create
    @cint_survey = CintSurvey.find(params[:cint_survey_id])

    if @cint_survey.activated_at.nil?
      @cint_survey.create_cint_survey_and_add_cint_id
    else
      @cint_survey.update_status(status: 'live')
    end

    redirect_to survey_cint_surveys_url(@cint_survey.survey)
  end

  def destroy
    @cint_survey = CintSurvey.find(params[:id])
    @cint_survey.update_status(status: 'paused')

    redirect_to survey_cint_surveys_url(@cint_survey.survey)
  end
end
