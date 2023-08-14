# frozen_string_literal: true

class Employee::SalesBaseController < Employee::BaseController
  layout 'sales'
  before_action :set_nav_section

  private

  def set_nav_section
    @active_nav_section = 'sales'
  end
end
