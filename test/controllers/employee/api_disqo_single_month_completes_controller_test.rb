# frozen_string_literal: true

require 'test_helper'

class Employee::ApiDisqoSingleMonthCompletesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  test 'should get index' do
    date = DateTime.now.utc
    get api_disqo_single_month_completes_url(date: date)
    assert_response :success
  end
end
