# frozen_string_literal: true

require 'test_helper'

class CleanIdDataVerificationTest < ActiveSupport::TestCase
  describe 'data is a string' do
    setup do
      Onboarding.any_instance.stubs(:run_cleanid_presurvey?).returns(true)
      @validator = CleanIdDataVerification.new(
        data: '{"error":{"message":"CORS Timeout."}}',
        onboarding: onboardings(:standard)
      )
    end

    it 'should fail' do
      assert @validator.fails_any_checks?
    end
  end
end
