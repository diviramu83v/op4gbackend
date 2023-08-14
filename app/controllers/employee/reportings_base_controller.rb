# frozen_string_literal: true

class Employee::ReportingsBaseController < Employee::BaseController
  layout 'reporting'
  before_action :set_nav_section

  private

  def set_nav_section
    @active_nav_section = 'reporting'
  end
end
