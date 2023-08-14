# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryProjectInclusionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#create' do
    it 'creates a project inclusion attached to the demo query and returns the json' do
      query = demo_queries(:standard)

      post query_project_inclusions_url(query), params: {
        demo_query_project_inclusion: {
          project_id: 1,
          survey_response_pattern_id: 1
        }
      }

      assert response.body['filter']
      assert_response :ok
    end
  end

  describe '#destroy' do
    it 'deletes the pma if it exists' do
      query = demo_queries(:standard)
      pmsa = pmsas(:standard)

      delete query_project_inclusion_url(query, pmsa)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
