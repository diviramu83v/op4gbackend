# frozen_string_literal: true

require 'test_helper'

class Employee::RecruitmentDashboardsControllerTest < ActionDispatch::IntegrationTest
  it 'gets the recruitment dashboard page' do
    load_and_sign_in_recruitment_employee

    get recruitment_dashboard_url

    assert_ok_with_no_warning
  end
end
