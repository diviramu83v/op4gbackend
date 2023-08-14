# frozen_string_literal: true

class Employee::SecurityBaseController < Employee::BaseController
  layout 'security'
  before_action :set_nav_section

  private

  def set_nav_section
    @active_nav_section = 'security'
  end
end
