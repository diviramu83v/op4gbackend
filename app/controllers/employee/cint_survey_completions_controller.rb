# frozen_string_literal: true

class Employee::CintSurveyCompletionsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def create
    @cint_survey = CintSurvey.find(params[:cint_survey_id])
    @cint_survey.complete!

    redirect_to survey_cint_surveys_url(@cint_survey.survey)
  end
end
