# frozen_string_literal: true

require 'test_helper'

class Employee::CampaignDemographicDetailsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  setup do
    @campaign = recruiting_campaigns(:standard)
    panel = panels(:standard)
    panelist = panelists(:standard)
    panelist.update(campaign_id: @campaign.id)
    panelist.save
    PanelMembership.create(panelist: panelist, panel: panel)
  end

  describe '#show' do
    it 'should return the generated csv' do
      get recruiting_campaign_demographic_details_url(@campaign, format: :csv)
      assert_response :ok
      assert_equal 'text/csv', response.content_type
    end
  end
end
