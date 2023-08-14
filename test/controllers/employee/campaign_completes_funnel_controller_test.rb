# frozen_string_literal: true

require 'test_helper'

class Employee::CampaignCompletesFunnelControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  test 'should get show' do
    campaign = recruiting_campaigns(:standard)
    get recruiting_campaign_completes_url(campaign)
    assert_response :success
  end
end
