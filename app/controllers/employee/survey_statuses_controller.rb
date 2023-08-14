# frozen_string_literal: true

class Employee::SurveyStatusesController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  before_action :set_survey

  def create
    @survey.assign_status(params[:status])

    return edit_survey(@survey) unless @survey.save

    redirect_to project_url(@survey.project)
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def edit_survey(survey)
    @survey = survey

    flash.now[:alert] = 'Unable to update survey status. Please add all required survey details first.'

    render 'employee/surveys/edit'
  end
end
