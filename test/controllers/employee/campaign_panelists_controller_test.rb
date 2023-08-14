# frozen_string_literal: true

require 'test_helper'

class Employee::CampaignPanelistLifecycleStatsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  it 'renders the index html view' do
    campaign = recruiting_campaigns(:standard)
    get recruiting_campaign_panelists_url(campaign)
    assert_response :success
  end

  it 'renders the index csv view' do
    campaign = recruiting_campaigns(:standard)
    get recruiting_campaign_panelists_url(campaign, format: :csv)
    assert_response :ok
  end
end
