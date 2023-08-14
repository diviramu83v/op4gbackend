# frozen_string_literal: true

require 'test_helper'

class Employee::TrafficStepLookupsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_admin
  end

  describe '#new' do
    it 'should load the page' do
      get new_traffic_step_lookup_url

      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @traffic_step_lookup = traffic_step_lookups(:standard)
    end

    it 'should load the page' do
      get traffic_step_lookup_url(@traffic_step_lookup)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @good_params = { traffic_step_lookup: { uids: '123' } }
      @bad_params = { traffic_step_lookup: { uids: '' } }
    end

    it 'should create lookup' do
      assert_difference -> { TrafficStepLookup.count } do
        post traffic_step_lookups_url, params: @good_params
      end
    end

    it 'should not create lookup' do
      assert_no_difference -> { TrafficStepLookup.count } do
        post traffic_step_lookups_url, params: @bad_params
      end
    end

    it 'should show flash' do
      post traffic_step_lookups_url, params: @bad_params

      assert_not_nil flash[:alert]
    end

    it 'should render new' do
      post traffic_step_lookups_url, params: @bad_params

      assert_template :new
    end
  end
end
