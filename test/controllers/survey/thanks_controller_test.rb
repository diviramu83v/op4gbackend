# frozen_string_literal: true

require 'test_helper'

class Survey::ThanksControllerTest < ActionDispatch::IntegrationTest
  it 'load the thanks page' do
    @onboarding = onboardings(:standard)

    get survey_thanks_url

    assert_ok_with_no_warning
  end
end
