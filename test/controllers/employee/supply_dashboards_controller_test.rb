# frozen_string_literal: true

require 'test_helper'

class Employee::SupplyDashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  describe 'GET /show' do
    it 'responds successfully' do
      get supply_dashboard_url
      assert_response :success
    end

    it 'assings @active_nav_section' do
      get supply_dashboard_url
      assert_equal 'supply', assigns(:active_nav_section)
    end
  end
end
