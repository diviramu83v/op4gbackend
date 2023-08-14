# frozen_string_literal: true

require 'test_helper'

class Employee::SchlesingerQuotaActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @quota = schlesinger_quotas(:standard)
  end

  describe '#create' do
    setup do
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
    end

    it 'should update the status to live' do
      post schlesinger_quota_schlesinger_quota_activations_url(@quota)

      @quota.reload
      assert @quota.live?
      assert_redirected_to survey_schlesinger_quotas_url(@quota.survey)
    end
  end

  describe '#destroy' do
    setup do
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
    end

    it 'should update the status to paused' do
      delete schlesinger_quota_activation_url(@quota)

      @quota.reload
      assert @quota.paused?
      assert_redirected_to survey_schlesinger_quotas_url(@quota.survey)
    end
  end
end
