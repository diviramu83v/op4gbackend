# frozen_string_literal: true

require 'test_helper'

class Employee::ApiCintSingleYearCompletesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    onboarding = Onboarding.complete.first
    onboarding.update(onramp: onramps(:cint))
    @year = Time.zone.now.year
  end

  test 'should get index' do
    get api_cint_single_year_completes_url(year: @year)
    assert_response :success
  end
end
