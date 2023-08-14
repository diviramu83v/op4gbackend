# frozen_string_literal: true

class Employee::ReportingDashboardsController < Employee::ReportingsBaseController
  skip_authorization_check # Authorize individual dashboard elements.

  def show; end
end
