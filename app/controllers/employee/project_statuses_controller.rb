# frozen_string_literal: true

class Employee::ProjectStatusesController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  # rubocop:disable Metrics/AbcSize
  def create
    @project = Project.find(params[:project_id])

    # Check project with the new status.
    return edit_project unless @project.valid?

    @project.surveys_that_can_be_changed_to_status(status: params[:id])&.each do |survey|
      survey.assign_status(params[:id])

      return edit_survey(survey) unless survey.save

      # Check each vendor batch.
      survey.vendor_batches.each do |batch|
        return edit_vendor_batch(batch) unless batch.valid?
      end
    end

    redirect_to @project
  end
  # rubocop:enable Metrics/AbcSize

  private

  def edit_project
    flash.now[:alert] = 'Unable to update project status. Please add all required project details first.'

    render 'employee/projects/edit'
  end

  def edit_survey(survey)
    @survey = survey

    flash.now[:alert] = 'Unable to update survey status. Please add all required survey details first.'

    render 'employee/surveys/edit'
  end

  def edit_vendor_batch(batch)
    @batch = batch
    @survey = @batch.survey

    flash.now[:alert] = 'Unable to update survey vendor. Please add all required redirect details first.'

    render 'employee/vendor_batches/edit'
  end
end
