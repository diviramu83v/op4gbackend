# frozen_string_literal: true

class Employee::ProjectProductController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  def update
    @project = Project.find(params[:project_id])

    flash[:alert] = 'Unable to update project type.' unless @project.update(project_params)

    redirect_back fallback_location: projects_url
  end

  private

  def project_params
    params.require(:project).permit(:product_name)
  end
end
