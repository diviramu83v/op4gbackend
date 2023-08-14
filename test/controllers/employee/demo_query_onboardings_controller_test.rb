# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryOnboardingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#create' do
    it 'adds encoded uid onboardings failures to the demo query' do
      query = demo_queries(:standard)

      post query_onboardings_url(query), params: { demo_query_onboardings: { encoded_uids: 'encoded-uid' } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'adds encoded uid onboardings failures to the demo query' do
      query = demo_queries(:standard)
      onboarding = onboardings(:second)

      post query_onboardings_url(query), params: { demo_query_onboardings: { encoded_uids: onboarding.token } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'catches RecordNotUnique errors and records them as failures' do
      query = demo_queries(:standard)
      onboarding = onboardings(:standard)

      post query_onboardings_url(query), params: { demo_query_onboardings: { encoded_uids: onboarding.token } }

      assert response.body['filter']
      assert_response :ok
    end
  end

  describe '#destroy' do
    it 'removes the encoded uid filter' do
      query = demo_queries(:standard)
      onboarding = onboardings(:standard)

      delete query_onboarding_url(query, onboarding)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
