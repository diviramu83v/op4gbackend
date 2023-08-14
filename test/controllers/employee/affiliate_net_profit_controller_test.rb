# frozen_string_literal: true

require 'test_helper'

class Employee::AffiliateNetProfitControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  test 'should get show' do
    affiliate = affiliates(:one)
    get affiliate_profit_url(affiliate)
    assert_response :success
  end
end
