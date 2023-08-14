# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryPmsasControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#create' do
    it 'adds the pma to the query if it is present and returns the json' do
      query = demo_queries(:standard)
      pmsa = pmsas(:not_linked)

      post query_pmsas_url(query), params: { demo_query_pmsa: { pmsa_id: pmsa.id } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'should update the feasibility total when a feasibility query is created' do
      feasibility_query = demo_queries(:feasibility_query)
      pmsa = pmsas(:not_linked)

      post query_pmsas_url(feasibility_query), params: { demo_query_pmsa: { pmsa_id: pmsa.id } }

      assert response.body['filter']
      assert_response :ok
      assert_not_nil DemoQueryPmsa.last.demo_query.feasibility_total
    end
  end

  describe '#destroy' do
    it 'deletes the pma if it exists' do
      query = demo_queries(:standard)
      pmsa = pmsas(:standard)

      delete query_pmsa_url(query, pmsa)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
