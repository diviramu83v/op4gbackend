# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryTrafficControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#show' do
    it 'shows the traffic controller page' do
      query = demo_queries(:standard)

      get query_traffic_url(query)

      assert_response :ok
    end
  end
end
