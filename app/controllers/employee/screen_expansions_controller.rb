# frozen_string_literal: true

class Employee::ScreenExpansionsController < Employee::OperationsBaseController
  skip_authorization_check

  def create
    session[:fluid] = true

    redirect_back fallback_location: employee_dashboard_url
  end

  def destroy
    session[:fluid] = nil

    redirect_back fallback_location: employee_dashboard_url
  end
end
