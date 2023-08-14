# frozen_string_literal: true

class Employee::SurveyApiTargetActivationsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  before_action :set_survey, :set_target

  def create
    @survey_api_target.update!(status: SurveyApiTarget.statuses[:active])

    redirect_to survey_api_target_url(@survey)
  end

  def destroy
    @survey_api_target.update!(status: SurveyApiTarget.statuses[:inactive])

    redirect_to survey_api_target_url(@survey)
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def set_target
    @survey_api_target = @survey.survey_api_target
  end
end
