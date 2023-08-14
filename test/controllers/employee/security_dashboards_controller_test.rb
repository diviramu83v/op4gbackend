# frozen_string_literal: true

require 'test_helper'

class Employee::SecurityDashboardsControllerTest < ActionDispatch::IntegrationTest
  it 'shows the security dashboard to a security employee' do
    load_and_sign_in_security_employee

    get security_dashboard_url

    assert_ok_with_no_warning
  end
end
