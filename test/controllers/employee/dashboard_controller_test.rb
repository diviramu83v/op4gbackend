# frozen_string_literal: true

require 'test_helper'

class Employee::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_base_employee
  end

  describe '#index' do
    it 'responds successfully' do
      get employee_dashboard_url
      assert_response :ok
    end
  end
end
