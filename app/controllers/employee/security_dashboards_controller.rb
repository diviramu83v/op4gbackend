# frozen_string_literal: true

class Employee::SecurityDashboardsController < Employee::SecurityBaseController
  skip_authorization_check # Authorize individual dashboard elements.

  def show; end
end
