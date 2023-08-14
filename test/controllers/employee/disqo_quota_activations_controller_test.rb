# frozen_string_literal: true

require 'test_helper'

class Employee::DisqoQuotaActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @quota = disqo_quotas(:standard)
  end

  describe '#create' do
    setup do
      stub_disqo_project_and_quota_status_change
    end

    it 'should update the status to live' do
      post disqo_quota_activations_url(@quota)

      @quota.reload
      assert @quota.live?
      assert_redirected_to survey_disqo_quotas_url(@quota.survey)
    end
  end

  describe '#destroy' do
    setup do
      stub_disqo_project_and_quota_status_change
    end

    it 'should update the status to paused' do
      delete activation_url(@quota)

      @quota.reload
      assert @quota.paused?
      assert_redirected_to survey_disqo_quotas_url(@quota.survey)
    end
  end
end
