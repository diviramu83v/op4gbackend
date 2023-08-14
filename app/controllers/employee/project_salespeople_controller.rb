# frozen_string_literal: true

class Employee::ProjectSalespeopleController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  def update
    @project = Project.find(params[:project_id])

    flash[:alert] = 'Unable to update salesperson.' unless @project.update(project_params)

    redirect_back fallback_location: projects_url
  end

  private

  def project_params
    params.require(:project).permit(:salesperson_id)
  end
end
