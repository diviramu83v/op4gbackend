# frozen_string_literal: true

class Employee::DashboardController < Employee::BaseController
  skip_authorization_check # Authorize individual dashboard elements.

  def index
    @panels = Panel.active
    @panelist_counts = @panels.joins(:panelists).where(panelists: { status: 'active' }).group('panels.id').count
  end
end
