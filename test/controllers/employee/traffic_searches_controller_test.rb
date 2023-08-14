# frozen_string_literal: true

require 'test_helper'

class Employee::TrafficSearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @onboarding = onboardings(:standard)
    @survey = surveys(:standard)
  end

  describe '#create' do
    it 'should redirect to the record if it exists' do
      post survey_traffic_search_url(@survey), params: { traffic_search: { token_or_uid: @onboarding.uid } }

      assert_redirected_to traffic_record_url(@onboarding)
    end

    it 'should redirect back to the details page if the record is not found' do
      post survey_traffic_search_url(@survey), params: { traffic_search: { token_or_uid: 'qwerty' } }

      assert_redirected_to survey_traffic_details_url(@survey)
    end
  end
end
