# frozen_string_literal: true

require 'test_helper'

class Employee::TrafficRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @onboarding = onboardings(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get traffic_record_url(@onboarding)
      assert_response :ok
    end
  end
end
