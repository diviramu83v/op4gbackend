# frozen_string_literal:true

require 'test_helper'

class Employee::CampaignNetProfitControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  test 'should get show' do
    campaign = recruiting_campaigns(:standard)
    get recruiting_campaign_profit_url(campaign)
    assert_response :success
  end
end
