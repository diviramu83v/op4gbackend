# frozen_string_literal: true

class Employee::ClientProjectsController < Employee::OperationsBaseController
  authorize_resource class: 'Client'
  authorize_resource class: 'Project'

  def new
    @client = Client.find(params[:client_id])
    @project = @client.projects.new
  end

  def create
    @client = Client.find(params[:client_id])
    @project = @client.projects.new(project_params.merge(manager: current_employee))

    if @project.save
      @project.add_survey if @project.surveys.empty?
      redirect_to edit_project_path(@project)
    else
      render 'new'
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
