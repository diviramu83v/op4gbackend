# frozen_string_literal: true

require 'test_helper'

class Employee::RecruitingCampaignEarningsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee

    @recruiting_campaign = recruiting_campaigns(:standard)
    @affiliate = affiliates(:one)
    @nonprofit = nonprofits(:one)
    @nonprofit.update(campaigns: [@recruiting_campaign])

    panelist = panelists(:standard)
    panelist.update(campaign: @recruiting_campaign)

    offer_panelist = panelists(:standard)
    offer_panelist.update(affiliate_code: @affiliate.code)

    survey = surveys(:standard)

    onramp = onramps(:panel)
    onramp.update(survey: survey)

    onboarding = onboardings(:standard)
    onboarding.update(panelist: panelist,
                      onramp: onramp,
                      status: :survey_finished,
                      survey_finished_at: Time.now.utc)

    offer_onboarding = onboardings(:standard)
    offer_onboarding.update(panelist: panelist,
                            onramp: onramp,
                            status: :survey_finished,
                            survey_finished_at: Time.now.utc)

    earning = earnings(:one)
    earning.update(onboarding: onboarding)

    earning = earnings(:one)
    earning.update(onboarding: offer_onboarding)

    survey_response_url = survey_response_urls(:complete)
    survey_response_url.update(onboardings: [onboarding], slug: :complete)
  end

  describe '#show' do
    it 'should produce correct report data with a recruiting campaign' do
      get recruiting_campaign_earnings_url(@recruiting_campaign)

      assert_response :ok
      assert_equal true, @controller.view_assigns['report_name'].present?
      assert_equal(-100.0, @controller.view_assigns['report_data'][2023][2023])
    end

    it 'should produce correct report data with an offer' do
      get affiliate_earnings_url(@affiliate)

      assert_response :ok
      assert_equal true, @controller.view_assigns['report_name'].present?
      assert_equal(-100.0, @controller.view_assigns['report_data'][2023][2023])
    end

    it 'should produce correct report data with a nonprofit' do
      get nonprofit_earnings_url(@nonprofit)

      assert_response :ok
      assert_equal true, @controller.view_assigns['report_name'].present?
      assert_equal(-100.0, @controller.view_assigns['report_data'][2023][2023])
    end
  end
end
