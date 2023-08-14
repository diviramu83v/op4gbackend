# frozen_string_literal: true

class Employee::OperationsBaseController < Employee::BaseController
  layout 'operations'
  before_action :set_nav_section

  private

  def set_nav_section
    @active_nav_section = 'operations'
  end
end
