# frozen_string_literal: true

require 'test_helper'

class Employee::VendorPerformanceReportsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_operations_employee
  end

  describe '#new' do
    it 'should load the page' do
      get new_vendor_performance_report_url

      assert_response :ok
    end
  end
end
