# frozen_string_literal: true

require 'test_helper'

class Employee::EarningsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @invitation = project_invitations(:standard)
  end

  describe '#index' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should load the index page' do
      get survey_earnings_url(@survey)

      assert_response :ok
    end
  end

  it 'load new earnings page' do
    @survey = surveys(:standard)

    get new_survey_earning_url(@survey)

    assert_response :ok
  end

  it 'earnings batch added successfully' do
    onboarding = onboardings(:standard)
    onboarding.update!(uid: @invitation.token, onramp: onramps(:panel))
    @onramp = onboarding.onramp
    @survey = @onramp.survey
    @traffic_records = @onramp.onboardings

    @ids = @traffic_records.pluck(:uid).join("\r\n")
    @params = { earnings_batch: { amount: 100, ids: @ids } }

    assert_difference -> { EarningsBatch.count } do
      post survey_earnings_url(@survey), params: @params
    end
  end

  it 'only creates earning once if batch submitted twice' do
    Earning.delete_all
    onboarding = onboardings(:standard)
    onboarding.update!(uid: @invitation.token, onramp: onramps(:panel))
    onboarding.add_invitation_if_appropriate
    onboarding.add_panelist_if_appropriate
    onboarding.add_panel_if_appropriate
    @onramp = onboarding.onramp
    @survey = @onramp.survey
    @traffic_records = @onramp.onboardings

    @ids = @traffic_records.pluck(:uid).join("\r\n")
    @params = { earnings_batch: { amount: 100, ids: @ids } }

    assert_difference -> { Earning.count } do
      post survey_earnings_url(@survey), params: @params
      post survey_earnings_url(@survey), params: @params
    end
  end

  it 'earnings records added successfully' do
    onboarding = onboardings(:standard)
    onboarding.update!(uid: @invitation.token)
    onboarding.onramp = onramps(:panel)
    @onramp = onboarding.onramp
    @survey = @onramp.survey
    @traffic_records = @onramp.onboardings

    @ids = @traffic_records.pluck(:uid).join("\r\n")
    @params = { earnings_batch: { amount: 100, ids: @ids } }

    assert_difference -> { Earning.count }, @traffic_records.count do
      post survey_earnings_url(@survey), params: @params
    end
  end

  it 'extra lines are ignored' do
    @onramp = onramps(:panel)
    @survey = @onramp.survey
    @traffic_records = @onramp.onboardings

    @ids = @traffic_records.pluck(:uid).join("\r\n\r\n\r\n")
    @params = { earnings_batch: { amount: 100, ids: @ids } }

    assert_difference -> { Earning.count }, @traffic_records.count do
      post survey_earnings_url(@survey), params: @params
    end
  end

  describe '#destroy' do
    setup do
      sign_in employees(:admin)
      @earning = earnings(:one)
      @survey = @earning.earnings_batch.survey
    end

    test 'removes the earning record' do
      assert_contains @survey.earnings, @earning
      assert_difference 'Earning.count', -1 do
        delete survey_earnings_url(@survey)
      end
      @survey.earnings.reload
      assert_does_not_contain @survey.earnings, @earning

      assert_redirected_to survey_earnings_url(@survey)
    end
  end
end
