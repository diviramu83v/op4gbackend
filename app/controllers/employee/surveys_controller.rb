# frozen_string_literal: true

class Employee::SurveysController < Employee::OperationsBaseController
  authorize_resource

  def show
    @survey = Survey.find(params[:id])
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    @survey = @project.add_survey

    redirect_to project_url(@project, anchor: "survey-#{@survey.id}")
  end

  def update
    @survey = Survey.find(params[:id])

    if @survey.update(survey_params)
      redirect_to survey_url(@survey)
    else
      flash.now[:alert] = 'Unable to update survey.'
      render 'edit'
    end
  end

  def destroy
    @survey = Survey.find(params[:id])

    if @survey.removable? && @survey.destroy
      flash[:notice] = 'Survey removed successfully.'
    else
      flash[:alert] = 'Unable to remove survey.'
    end

    redirect_to survey_url(@survey)
  end

  private

  def survey_params
    params.require(:survey).permit(:name, :base_link, :client_test_link, :target, :cpi, :loi, :prevent_overlapping_invitations, :category, :audience,
                                   :country_id, :language)
  end
end
