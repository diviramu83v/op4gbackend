# frozen_string_literal: true

require 'test_helper'

class Employee::PersonalProjectReportsControllerTest < ActionDispatch::IntegrationTest
  describe '#create' do
    setup do
      @admin_employee = employees(:admin)
      sign_in @admin_employee
      @project = projects(:standard)
      @project.update(manager: @admin_employee)
    end

    it 'should download the csv' do
      get personal_project_reports_url(status: @status, format: :csv)

      assert_response :ok
    end

    test 'status: all' do
      get personal_project_reports_url(status: 'all', format: :csv)

      assert_response :ok
    end

    test 'status: active' do
      get personal_project_reports_url(status: 'active', format: :csv)

      assert_response :ok
    end
  end
end
