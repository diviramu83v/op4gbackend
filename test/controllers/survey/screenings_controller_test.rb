# frozen_string_literal: true

require 'test_helper'

class Survey::ScreeningsControllerTest < ActionDispatch::IntegrationTest
  it 'load the screenout page' do
    @onboarding = onboardings(:standard)

    get survey_screened_url(token: @onboarding.response_token)

    assert_ok_with_no_warning
  end

  it 'loading the screenout page uses the response token' do
    @onboarding = onboardings(:standard)

    assert_nil @onboarding.response_token_used_at

    get survey_screened_url(token: @onboarding.response_token)
    @onboarding.reload

    assert_not_nil @onboarding.response_token_used_at
  end

  it 'disallow loading the screenout page with no token' do
    @onboarding = onboardings(:standard)

    get survey_screened_url

    assert_redirected_to survey_error_url
  end

  it 'disallow loading the screenout page with a bad token' do
    @onboarding = onboardings(:standard)

    get survey_screened_url(token: 'bad-token')

    assert_redirected_to survey_error_url
  end

  it "disallow loading the screenout page with a token that's already been used" do
    @onboarding = onboardings(:standard)

    get survey_screened_url(token: @onboarding.response_token)
    get survey_screened_url(token: @onboarding.response_token)

    assert_redirected_to survey_error_url
  end
end
