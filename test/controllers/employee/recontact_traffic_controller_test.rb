# frozen_string_literal: true

require 'test_helper'

class Employee::RecontactTrafficControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @recontact = surveys(:standard)
  end

  describe '#show' do
    test 'page loads' do
      get recontact_traffic_url(@recontact)
      assert_response :ok
    end
  end
end
