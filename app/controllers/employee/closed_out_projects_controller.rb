# frozen_string_literal: true

class Employee::ClosedOutProjectsController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  def index
    @projects = Project.finalized.order(close_out_status: :desc).page(params[:page]).per(30)
  end
end
