# frozen_string_literal: true

class Employee::RedirectLogsController < Employee::OperationsBaseController
  authorize_resource

  def index
    @project = Project.find(params[:project_id])
    @logs = @project.redirect_logs
    @logs = @logs.page(params[:page]).per(50)
  end
end
