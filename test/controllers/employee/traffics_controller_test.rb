# frozen_string_literal: true

require 'test_helper'

class Employee::TrafficsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @survey = surveys(:standard)
  end

  describe '#show' do
    test 'page loads' do
      get survey_traffic_url(@survey)
      assert_response :ok
    end
  end
end
