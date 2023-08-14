# frozen_string_literal: true

require 'test_helper'

class Employee::OperationsDashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'view dashboard' do
    get operations_dashboard_url

    assert_response :ok
  end
end
