# frozen_string_literal: true

require 'test_helper'

class ApiDisqoSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  describe '#index' do
    test 'should get index' do
      get api_disqo_surveys_url
      assert_response :success
    end

    test 'should load with all status' do
      get api_disqo_surveys_url, params: { status: 'all' }
      assert_response :success
    end

    test 'should load with live status' do
      get api_disqo_surveys_url, params: { status: 'live' }
      assert_response :success
    end
  end
end
