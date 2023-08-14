# frozen_string_literal: true

class Employee::SupplyBaseController < Employee::BaseController
  layout 'supply'
  before_action :set_nav_section

  private

  def set_nav_section
    @active_nav_section = 'supply'
  end
end
