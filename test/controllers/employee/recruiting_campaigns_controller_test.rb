# frozen_string_literal: true

require 'test_helper'

class Employee::RecruitingCampaignsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
    @recruiting_campaign = recruiting_campaigns(:standard)
  end

  describe '#index' do
    it 'should retrieve the recruiting campaigns list' do
      get recruiting_campaigns_url

      assert_response :ok
      assert_template :index
    end
  end

  describe '#show' do
    it 'gets the recruiting campaign page' do
      get recruiting_campaign_url(@recruiting_campaign)

      assert_ok_with_no_warning
    end
  end

  describe '#edit' do
    it 'gets the edit recruiting campaign page' do
      get edit_recruiting_campaign_url(@recruiting_campaign)

      assert_ok_with_no_warning
    end
  end

  describe '#create' do
    it 'should create a new campaign' do
      assert_difference -> { RecruitingCampaign.count } do
        post recruiting_campaigns_url, params: { recruiting_campaign: { code: '1234' } }
      end

      assert_redirected_to recruiting_campaign_url(RecruitingCampaign.last)
    end

    it 'should not create a new campaign if code is missing' do
      assert_no_difference -> { RecruitingCampaign.count } do
        post recruiting_campaigns_url, params: { recruiting_campaign: { code: nil } }
      end
    end
  end

  describe '#update' do
    it 'updates the recruiting campaign' do
      put recruiting_campaign_url(@recruiting_campaign), params: { recruiting_campaign: @recruiting_campaign.attributes }

      assert_redirected_to @recruiting_campaign
    end

    it 'loads the view for a new campaign if it cannot update the current campaign' do
      @recruiting_campaign.code = nil # invalidate so update fails
      @recruiting_campaign.save

      put recruiting_campaign_url(@recruiting_campaign), params: { recruiting_campaign: @recruiting_campaign.attributes }

      assert_ok_with_no_warning
    end
  end
end
