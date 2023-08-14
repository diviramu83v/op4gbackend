# frozen_string_literal: true

class Employee::SupplyDashboardsController < Employee::SupplyBaseController
  skip_authorization_check

  def show; end
end
