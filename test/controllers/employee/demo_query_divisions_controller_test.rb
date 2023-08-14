# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryDivisionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#create' do
    it 'adds the demo query division if it is present and returns the json' do
      query = demo_queries(:standard)
      division = demo_query_divisions(:standard)

      post query_divisions_url(query), params: { division: division }

      assert response.body['filter']
      assert_response :ok
    end

    it 'does nothing if the demo query division is not present' do
      query = demo_queries(:standard)
      division = demo_query_divisions(:standard)

      post query_divisions_url(query), params: { division: division }

      assert response.body['filter']
      assert_response :ok
    end

    it 'should update the feasibility total when a feasibility query is created' do
      feasibility_query = demo_queries(:feasibility_query)
      division = demo_query_divisions(:feasibility)

      post query_divisions_url(feasibility_query), params: { division: division }

      assert response.body['filter']
      assert_response :ok
      assert_not_nil DemoQuery.last.feasibility_total
    end
  end

  describe '#destroy' do
    it 'deletes the demo query division if it exists' do
      query = demo_queries(:standard)
      division = demo_query_divisions(:standard)

      delete query_division_url(query, division)

      assert response.body['filter']
      assert_response :ok
    end

    it 'does nothing if the demo query division doesn\'t exist' do
      query = demo_queries(:standard)
      division = demo_query_divisions(:standard)

      delete query_division_url(query, division)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
