# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryZipCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#index' do
    it 'renders the index view' do
      query = demo_queries(:standard)

      get query_zips_url(query)

      assert_response :ok
    end
  end

  describe '#create' do
    it 'catches a duplicate demo zip code as a failure and returns the json' do
      query = demo_queries(:standard)

      post query_zips_url(query), params: { demo_query_zip: { zips: '11111' } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'adds the valid zip code to the query, records it as a success, and returns the json' do
      query = demo_queries(:standard)

      post query_zips_url(query), params: { demo_query_zip: { zips: '22222' } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'adds the invalid zip as a failure and returns the json' do
      query = demo_queries(:standard)

      post query_zips_url(query), params: { demo_query_zip: { zips: '33333' } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'should update the feasibility total when a feasibility query is created' do
      feasibility_query = demo_queries(:feasibility_query)

      post query_zips_url(feasibility_query), params: { demo_query_zip: { zips: '22222' } }

      assert response.body['filter']
      assert_response :ok
      assert_not_nil DemoQuery.last.feasibility_total
    end
  end

  describe '#destroy' do
    it 'deletes the pma if it exists' do
      query = demo_queries(:standard)
      zip = zip_codes(:standard)

      delete query_zip_url(query, zip)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
