# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryAgeRangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)

    @demo_query = demo_queries(:standard)
  end

  describe '#create' do
    it 'should query an age range' do
      post query_age_ranges_url(@demo_query), params: { from: 41, to: 43 }
      assert_response :ok
    end

    it 'should update the feasibility total when a feasibility query is created' do
      @feasibility_query = demo_queries(:feasibility_query)

      post query_age_ranges_url(@feasibility_query), params: { from: 41, to: 43 }
      assert_response :ok

      assert_not_nil DemoQueryAge.last.demo_query.feasibility_total
    end
  end
end
