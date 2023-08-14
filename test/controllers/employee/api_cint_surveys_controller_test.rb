# frozen_string_literal: true

require 'test_helper'

class ApiCintSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  describe '#index' do
    test 'should get index' do
      get api_cint_surveys_url
      assert_response :success
    end

    test 'should load with all status' do
      get api_cint_surveys_url, params: { status: 'all' }
      assert_response :success
    end

    test 'should load with draft status' do
      get api_cint_surveys_url, params: { status: 'draft' }
      assert_response :success
    end

    test 'should load with live status' do
      get api_cint_surveys_url, params: { status: 'live' }
      assert_response :success
    end

    test 'should load with paused status' do
      get api_cint_surveys_url, params: { status: 'paused' }
      assert_response :success
    end

    test 'should load with halted status' do
      get api_cint_surveys_url, params: { status: 'halted' }
      assert_response :success
    end

    test 'should load with complete status' do
      get api_cint_surveys_url, params: { status: 'complete' }
      assert_response :success
    end

    test 'should load with closed status' do
      get api_cint_surveys_url, params: { status: 'closed' }
      assert_response :success
    end

    test 'should load with activation failed status' do
      get api_cint_surveys_url, params: { status: 'activation_failed' }
      assert_response :success
    end
  end
end
