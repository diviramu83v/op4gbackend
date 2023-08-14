# frozen_string_literal: true

require 'test_helper'

class Employee::SalesDashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_sales_employee
  end

  describe '#show' do
    it 'renders' do
      get sales_dashboard_url

      assert_template :show
    end
  end
end
