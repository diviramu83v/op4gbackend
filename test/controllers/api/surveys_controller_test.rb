# frozen_string_literal: true

require 'test_helper'

class Api::SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = api_tokens(:standard)
    @survey = surveys(:standard)
    @target = survey_api_targets(:standard)
    @onramp = onramps(:api)
    stub_disqo_project_and_quota_status_change
  end

  describe '#index' do
    it 'returns the appropriate data' do
      get v1_surveys_url, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      body = JSON.parse(response.body)

      assert_equal 200, body['status']
      assert_equal 1, body['count']

      offer = body['offers'].first

      assert_equal @onramp.project.id, offer['project_id']
      assert_equal 15, offer['loi_minutes']
      assert_equal '1.50', offer['payout_dollars']

      assert_equal ['US'], offer['target']['country']
      assert_equal ['female'], offer['target']['gender']
      assert_equal [*25..35], offer['target']['age']

      test_state_abbrevs = %w[ID]
      assert_equal test_state_abbrevs, offer['target']['states']

      test_states = State.where(code: test_state_abbrevs)
      test_zips = ZipCode.where(state: test_states)

      assert_equal test_zips.any?, true
      assert_equal test_zips.map(&:code), offer['target']['zip_codes']
    end

    it 'should not return surveys with projects that are not live' do
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      get v1_surveys_url, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      # Count the API results
      body = JSON.parse(response.body)
      original_offers = body['offers']
      original_offers_count = original_offers.count
      assert original_offers_count.positive?

      ########## all of this code won't work with caching. I'm leaving it here in case we want to address that
      # Update the project status of one of the offers to something other than live
      first_offer = original_offers.first
      onramp = Onramp.where(token: first_offer['uuid']).first
      onramp.survey.update!(status: 'hold')

      get v1_surveys_url, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      # Count the API results again after making an offer ineligible
      body = JSON.parse(response.body)
      new_offers = body['offers']
      new_offers_count = new_offers.count
      assert new_offers_count == original_offers_count - 1
    end
  end
end
