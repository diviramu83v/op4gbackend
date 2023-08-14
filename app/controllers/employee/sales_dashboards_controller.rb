# frozen_string_literal: true

class Employee::SalesDashboardsController < Employee::SalesBaseController
  authorize_resource class: 'Project'

  def show; end
end
