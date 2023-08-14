# frozen_string_literal: true

class Employee::SurveyTestModesController < Admin::BaseController
  def update
    if current_employee.survey_test_mode.easy_mode?
      current_employee.survey_test_mode.update!(easy_test: false)
    else
      current_employee.survey_test_mode.update!(easy_test: true)
    end
    redirect_back(fallback_location: employee_dashboard_url)
  end
end
