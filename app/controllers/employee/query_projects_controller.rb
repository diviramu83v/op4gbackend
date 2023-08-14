# frozen_string_literal: true

class Employee::QueryProjectsController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  def new
    @query = DemoQuery.find(params[:query_id])
    @project = Project.new
  end

  def create
    @query = DemoQuery.find(params[:query_id])
    @project = Project.new(project_params.merge(manager: current_employee))

    if @project.save
      @project.add_survey
      @project.add_query(@query)

      redirect_to @project
    else
      flash.now[:alert] = 'Unable to save project.'
      render 'new'
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :client_id)
  end
end
