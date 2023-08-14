# frozen_string_literal: true

class Employee::PanelsController < Employee::RecruitmentBaseController
  authorize_resource
  before_action :load_active_panels, :load_inactive_panels, only: [:index]

  def index; end

  def show
    @panel = Panel.find(params['id'])
  end

  private

  def load_active_panels
    @panels = Panel.standard.active.viewable(current_user).sort_by(&:active_panelist_count).reverse!
    @locked_panels = Panel.locked.active.viewable(current_user).sort_by(&:active_panelist_count).reverse!
  end

  def load_inactive_panels
    @inactive_panels = Panel.standard.inactive.viewable(current_user).sort_by(&:active_panelist_count).reverse!
    @inactive_locked_panels = Panel.locked.inactive.viewable(current_user).sort_by(&:active_panelist_count).reverse!
  end
end
