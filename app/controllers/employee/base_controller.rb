# frozen_string_literal: true

class Employee::BaseController < ApplicationController
  layout 'employee'

  # Load all roles for the current employee.
  def current_employee
    @current_employee ||= super && Employee.includes(:roles).where(id: current_employee.id).first
  end

  def effective_role
    @effective_role = session[:effective_role]
  end

  # Lock the employee section down with Cancan.
  alias current_user current_employee
  check_authorization unless: :devise_controller?
  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { head :unauthorized, content_type: 'text/html' }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
end
