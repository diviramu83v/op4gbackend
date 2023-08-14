# frozen_string_literal: true

require 'test_helper'

class Employee::TrafficBySourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
    @survey = surveys(:standard)
  end

  describe '#show' do
    it 'should render ok' do
      get survey_traffic_by_source_url(@survey)
      assert_response :ok
    end
  end
end
