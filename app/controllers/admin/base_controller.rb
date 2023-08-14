# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  skip_before_action :record_event

  before_action :authenticate_system!

  layout 'admin'

  def authenticate_system!
    redirect_to not_found_url unless employee_is_authorized
  end

  def employee_is_authorized
    current_employee&.effective_role_admin?(@effective_role) || current_employee&.effective_role_include?('Payment', @effective_role)
  end
end
