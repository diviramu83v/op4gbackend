# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryStateCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#create' do
    setup do
      @query = demo_queries(:standard)
      @demo_query_state_code = State::QUERY.values.flatten.first

      @params = { query_id: @query.id, code: @demo_query_state_code }
    end

    it 'should ignore multiple posts with the same options' do
      assert_difference -> { DemoQueryStateCode.count }, 1 do
        post query_state_codes_url(@query), params: @params
        post query_state_codes_url(@query), params: @params
      end

      assert_ok_with_no_warning
    end

    it 'should update the feasibility total when a feasibility query is created' do
      @feasibility_query = demo_queries(:feasibility_query)

      assert_difference -> { DemoQueryStateCode.count }, 1 do
        post query_state_codes_url(@feasibility_query), params: @params
      end

      assert_ok_with_no_warning
      assert_not_nil DemoQueryStateCode.last.demo_query.feasibility_total
    end

    test 'create failed flash message' do
      ActiveRecord::Associations::CollectionProxy.any_instance.expects(:create).returns(false)

      post query_state_codes_url(@query), params: @params

      assert_equal 'Unable to add state code filter.', flash[:alert]
    end
  end

  describe '#destroy' do
    setup do
      demo_query_state_code = demo_query_state_codes(:standard)
      @query = demo_query_state_code.demo_query
      @state_code = demo_query_state_code.code
    end

    it 'should remove state from demo query' do
      assert_difference -> { DemoQueryStateCode.count }, -1 do
        delete query_state_code_url(@query, @state_code)
      end
    end

    test 'destroy failed flash message' do
      DemoQueryStateCode.any_instance.expects(:delete).returns(false)

      delete query_state_code_url(@query, @state_code)

      assert_equal 'Unable to remove state code filter', flash[:alert]
    end
  end
end
