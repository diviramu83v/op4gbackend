# frozen_string_literal: true

class Employee::OperationsDashboardsController < Employee::OperationsBaseController
  skip_authorization_check # Authorize individual dashboard elements.

  def show
    @projects = Project.order('id DESC').limit 5
  end
end
