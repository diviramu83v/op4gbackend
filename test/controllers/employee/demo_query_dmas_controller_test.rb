# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryDmasControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#create' do
    it 'adds the dma to the query if it is present and returns the json' do
      query = demo_queries(:standard)
      dma = dmas(:not_linked)

      post query_dmas_url(query), params: { demo_query_dma: { dma_id: dma.id } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'does nothing if the dma is not present' do
      query = demo_queries(:standard)
      dma = dmas(:not_linked)

      post query_dmas_url(query), params: { demo_query_dma: { dma_id: dma.id } }

      assert response.body['filter']
      assert_response :ok
    end

    it 'should update the feasibility total when a feasibility query is created' do
      feasibility_query = demo_queries(:feasibility_query)
      dma = dmas(:not_linked)

      post query_dmas_url(feasibility_query), params: { demo_query_dma: { dma_id: dma.id } }

      assert response.body['filter']
      assert_response :ok
      assert_not_nil DemoQueryDma.last.demo_query.feasibility_total
    end
  end

  describe '#destroy' do
    it 'deletes the dma if it exists' do
      query = demo_queries(:standard)
      dma = dmas(:standard)

      delete query_dma_url(query, dma)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
