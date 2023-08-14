# frozen_string_literal: true

require 'test_helper'

class Employee::TrafficStepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @onboarding = onboardings(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get onboarding_traffic_steps_url(@onboarding)
      assert_response :ok
    end

    test 'when onramp category is recontact' do
      @onboarding.onramp.recontact!
      get onboarding_traffic_steps_url(@onboarding)
      assert_response :ok
    end

    test 'when onramp category is not recontact' do
      @onboarding.onramp.testing!
      get onboarding_traffic_steps_url(@onboarding)
      assert_response :ok
    end
  end
end
