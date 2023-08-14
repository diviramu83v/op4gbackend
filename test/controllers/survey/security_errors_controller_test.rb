# frozen_string_literal: true

require 'test_helper'

class Survey::SecurityErrorsControllerTest < ActionDispatch::IntegrationTest
  describe '#show' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'should load the page' do
      get survey_security_errors_url(onboarding_id: @onboarding.id)

      assert_response :ok
    end
  end
end
