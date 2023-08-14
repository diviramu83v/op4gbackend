# frozen_string_literal: true

class Employee::ProjectCloseOutsController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  def index
    @projects = Project.needs_closing_out_manager_first(current_employee)
    @projects = @projects.preload(:surveys, :manager).page(params[:page]).per(50)
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:close_out_status)
  end
end
