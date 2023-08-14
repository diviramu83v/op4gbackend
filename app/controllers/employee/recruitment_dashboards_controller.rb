# frozen_string_literal: true

class Employee::RecruitmentDashboardsController < Employee::RecruitmentBaseController
  skip_authorization_check # Authorize individual dashboard elements.

  def show; end
end
