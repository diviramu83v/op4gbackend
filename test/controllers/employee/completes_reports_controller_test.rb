# frozen_string_literal: true

require 'test_helper'

class Employee::CompletesReportsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_operations_employee
  end

  describe '#new' do
    it 'should load the page' do
      get new_completes_report_url

      assert_response :ok
    end
  end
end
