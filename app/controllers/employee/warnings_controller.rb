# frozen_string_literal: true

class Employee::WarningsController < Employee::OperationsBaseController
  authorize_resource class: 'SurveyWarning'

  def index
    @survey_warnings = SurveyWarning.active.joins(:survey, :project, :project_manager)

    return render if params[:employee_id].blank?

    @selected_project_manager = Employee.find(params[:employee_id])
    @survey_warnings = @survey_warnings.where(projects: { manager_id: @selected_project_manager.id })
  end

  def destroy
    @survey_warning = SurveyWarning.find(params[:id])
    @survey_warning.mark_as_inactive

    render 'destroy', locals: { warning_id: @survey_warning.id,
                                warning_pm: @survey_warning.project_manager.id,
                                warning_count: @survey_warning.project_manager.warning_count }
  end
end
