# frozen_string_literal: true

require 'test_helper'

class Employee::NonprofitCompletesFunnelControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  test 'should get show' do
    nonprofit = nonprofits(:one)
    get nonprofit_completes_url(nonprofit)
    assert_response :success
  end
end
