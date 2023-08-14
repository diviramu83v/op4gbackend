# frozen_string_literal: true

require 'test_helper'

class Employee::MembershipDashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#show' do
    it 'shows the membership dashboards view' do
      get membership_dashboard_url

      assert_ok_with_no_warning
      assert_template :show
    end
  end
end
