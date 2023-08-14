# frozen_string_literal: true

require 'test_helper'

class Survey::ReturnKeyErrorsControllerTest < ActionDispatch::IntegrationTest
  describe '#show' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'should load the page' do
      get survey_return_key_errors_url

      assert_response :ok
    end
  end
end
