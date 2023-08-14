# frozen_string_literal: true

require 'test_helper'

class Employee::ApiDisqoSingleYearCompletesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    onboarding = Onboarding.complete.first
    onboarding.update(onramp: onramps(:disqo))
    @year = Time.zone.now.year
  end

  test 'should get index' do
    get api_disqo_single_year_completes_url(year: @year)
    assert_response :success
  end
end
