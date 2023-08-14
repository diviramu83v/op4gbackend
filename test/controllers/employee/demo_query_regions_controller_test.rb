# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryRegionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#create' do
    it 'creates a project inclusion attached to the demo query and returns the json' do
      query = demo_queries(:standard)
      region = regions(:northeast)

      post query_regions_url(query, region)

      assert response.body['filter']
      assert_response :ok
    end

    it 'should update the feasibility total when a feasibility query is created' do
      feasibility_query = demo_queries(:feasibility_query)
      region = regions(:northeast)

      post query_regions_url(feasibility_query, region)

      assert response.body['filter']
      assert_response :ok
      assert_not_nil DemoQuery.last.feasibility_total
    end
  end

  describe '#destroy' do
    it 'deletes the pma if it exists' do
      query = demo_queries(:standard)
      region = regions(:northeast)

      delete query_region_url(query, region)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
