# frozen_string_literal: true

require 'test_helper'

class Survey::FillsControllerTest < ActionDispatch::IntegrationTest
  it 'load the full survey page' do
    @onboarding = onboardings(:standard)

    get survey_full_url(token: @onboarding.response_token)

    assert_ok_with_no_warning
  end

  it 'loading the full survey page uses the response token' do
    @onboarding = onboardings(:standard)

    assert_nil @onboarding.response_token_used_at

    get survey_full_url(token: @onboarding.response_token)
    @onboarding.reload

    assert_not_nil @onboarding.response_token_used_at
  end

  it 'disallow loading the full survey page with no token' do
    @onboarding = onboardings(:standard)

    get survey_full_url

    assert_redirected_to survey_error_url
  end

  it 'disallow loading the full survey page with a bad token' do
    @onboarding = onboardings(:standard)

    get survey_full_url(token: 'bad-token')

    assert_redirected_to survey_error_url
  end

  it "disallow loading the full survey page with a token that's already been used" do
    @onboarding = onboardings(:standard)

    get survey_full_url(token: @onboarding.response_token)
    get survey_full_url(token: @onboarding.response_token)

    assert_redirected_to survey_error_url
  end
end
