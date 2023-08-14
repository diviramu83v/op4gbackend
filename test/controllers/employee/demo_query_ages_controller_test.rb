# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryAgesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'add a demo query age filter, fail at deleting it, and then succeed at deleting it' do
    @query = demo_queries(:standard)
    @age = Age.find_or_create_by(value: 13)

    assert_difference -> { DemoQueryAge.count }, 1 do
      post query_ages_url(@query), params: { age_id: @age.id }
    end

    assert_ok_with_no_warning

    assert_no_difference -> { DemoQueryAge.count } do
      delete query_age_url(@query, 0)
    end

    assert_not_nil flash[:alert]
    assert_response :ok

    assert_difference -> { DemoQueryAge.count }, -1 do
      delete query_age_url(@query, @age.id)
    end
  end

  it 'fail at adding a demo query age filter for invalid age' do
    @query = demo_queries(:standard)

    assert_no_difference -> { DemoQueryAge.count } do
      post query_ages_url(@query), params: { age_id: 0 }
    end

    assert_not_nil flash[:alert]
    assert_response :ok
  end

  it 'should ignore multiple posts with the same options' do
    @query = demo_queries(:standard)
    @age = Age.find_or_create_by(value: 13)

    post query_ages_url(@query), params: { age_id: @age.id }
    post query_ages_url(@query), params: { age_id: @age.id }

    assert_response :ok
  end

  it 'should update the feasibility total when a feasibility query is created' do
    @feasibility_query = demo_queries(:feasibility_query)
    @age = Age.find_or_create_by(value: 13)

    assert_difference -> { DemoQueryAge.count }, 1 do
      post query_ages_url(@feasibility_query), params: { age_id: @age.id }
    end

    assert_ok_with_no_warning
    assert_not_nil DemoQueryAge.last.demo_query.feasibility_total
  end
end
