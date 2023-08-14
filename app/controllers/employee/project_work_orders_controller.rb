# frozen_string_literal: true

class Employee::ProjectWorkOrdersController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  def update
    @project = Project.find(params[:project_id])

    flash[:alert] = 'Unable to update work order.' unless @project.update(project_params)

    redirect_back fallback_location: projects_url
  end

  private

  def project_params
    params.require(:project).permit(:work_order)
  end
end
