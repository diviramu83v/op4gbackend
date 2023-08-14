# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryOptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'add option' do
    load_no_option_query
    @option = demo_options(:standard)

    assert_difference -> { DemoQueryOption.count } do
      post query_options_url(@query, option_id: @option.id)
    end

    assert_response :ok
    assert_nil flash[:alert]
  end

  it 'add option: missing option' do
    load_no_option_query

    assert_no_difference -> { DemoQueryOption.count } do
      post query_options_url(@query)
    end

    assert_response :ok
  end

  it 'add option: invalid option' do
    load_no_option_query

    assert_no_difference -> { DemoQueryOption.count } do
      post query_options_url(@query, option_id: -1)
    end

    assert_response :ok
    assert_equal 'Unable to add option filter.', flash[:alert]
  end

  it 'should update the feasibility total when a feasibility query is created' do
    load_no_option_query
    @feasibility_query = demo_queries(:feasibility_query)
    @option = demo_options(:standard)

    assert_difference -> { DemoQueryOption.count } do
      post query_options_url(@feasibility_query, option_id: @option.id)
    end

    assert_response :ok
    assert_nil flash[:alert]
    assert_not_nil DemoQueryOption.last.demo_query.feasibility_total
  end

  it 'remove option' do
    @option = demo_options(:standard)
    @query = demo_queries(:standard)

    assert_difference -> { DemoQueryOption.count }, -1 do
      delete query_option_url(@query, @option)
    end

    assert_response :ok
  end

  # 'remove option: missing option' not possible due to URL structure

  it 'remove option: invalid option' do
    @query = demo_queries(:standard)

    assert_no_difference -> { DemoQueryOption.count } do
      delete query_option_url(@query, id: -1)
    end

    assert_response :ok
    assert_equal 'Unable to remove option filter.', flash[:alert]
  end
end
