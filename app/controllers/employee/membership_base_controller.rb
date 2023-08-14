# frozen_string_literal: true

class Employee::MembershipBaseController < Employee::BaseController
  layout 'membership'
  before_action :set_nav_section

  private

  def set_nav_section
    @active_nav_section = 'membership'
  end
end
