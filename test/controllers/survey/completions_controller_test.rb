# frozen_string_literal: true

require 'test_helper'

class Survey::CompletionsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  it 'load the completion page' do
    @onboarding = onboardings(:standard)

    get survey_complete_url(token: @onboarding.response_token)

    assert_ok_with_no_warning
  end

  it 'loading the completion page uses the response token' do
    @onboarding = onboardings(:standard)

    assert_nil @onboarding.response_token_used_at

    get survey_complete_url(token: @onboarding.response_token)
    @onboarding.reload

    assert_not_nil @onboarding.response_token_used_at
  end

  it 'hide the follow-up form for most external vendor traffic' do
    @onboarding = onboardings(:standard)
    @onboarding.update!(onramp: onramps(:vendor))
    @onboarding.vendor.update!(collect_followup_data: false)

    get survey_complete_url(token: @onboarding.response_token)

    assert_select('form', count: 0)
  end

  it 'hide the follow-up form for panel traffic' do
    @onboarding = onboardings(:standard)
    @onboarding.update!(onramp: onramps(:panel))

    get survey_complete_url(token: @onboarding.response_token)

    assert_select('form', count: 0)
  end

  it 'disallow loading the completion page with no token' do
    @onboarding = onboardings(:standard)

    get survey_complete_url

    assert_redirected_to survey_error_url
  end

  it 'disallow loading the completion page with a bad token' do
    @onboarding = onboardings(:standard)

    get survey_complete_url(token: 'bad-token')

    assert_redirected_to survey_error_url
  end

  it "disallow loading the completion page with a token that's already been used" do
    @onboarding = onboardings(:standard)

    get survey_complete_url(token: @onboarding.response_token)
    get survey_complete_url(token: @onboarding.response_token)

    assert_redirected_to survey_error_url
  end
end
