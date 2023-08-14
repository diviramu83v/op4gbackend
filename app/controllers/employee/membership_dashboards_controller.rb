# frozen_string_literal: true

class Employee::MembershipDashboardsController < Employee::MembershipBaseController
  skip_authorization_check # Authorize individual dashboard elements.

  def show; end
end
