# frozen_string_literal: true

class Employee::SurveyClonesController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def create
    @survey = Survey.find(params[:survey_id])

    if @survey.clone_survey
      flash[:notice] = 'Successfully cloned survey.'
    else
      flash[:alert] = 'Unable to clone survey.'
    end

    redirect_to project_url(@survey.project)
  end
end
