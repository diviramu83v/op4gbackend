# frozen_string_literal: true

require 'test_helper'

class ApiFlowTest < ActionDispatch::IntegrationTest
  setup do
    ReturnKey.delete_all

    @onramp = onramps(:api)
    @vendor = @onramp.api_vendor

    # security: off
    Onboarding.any_instance.expects(:requires_security_checks?).returns(false).at_least_once
    TrafficAnalyzer.any_instance.expects(:failed_post_survey?).returns(false)
    TrafficAnalyzer.any_instance.expects(:flagged_post_survey?).returns(false)
  end

  describe 'hashing off' do
    test 'complete flow' do
      run_pre_survey_flow

      @response = @onramp.project.complete_response
      assert_difference 'Onboarding.complete.count' do
        get survey_response_url(@response, uid: @onboarding.token)
      end

      run_post_survey_steps

      assert_redirected_to @vendor.complete_url + @onboarding.uid
    end
  end

  describe 'hashing on' do
    setup do
      @vendor.update!(
        hash_key: '7c46dfa45f83967e9b8343a9f7c55c93',
        hashing_param: 'checksum',
        include_hashing_param_in_hash_data: true
      )
    end

    test 'term flow' do
      run_pre_survey_flow

      @response = @onramp.project.terminate_response
      assert_difference 'Onboarding.terminate.count' do
        get survey_response_url(@response, uid: @onboarding.token)
      end

      run_post_survey_steps

      assert_redirected_to 'https://api.vendor.com/term?uid=test&checksum=7c9921a6dd4e6f5df9ea52e4e7772688281ff136'
    end
  end

  def run_pre_survey_flow
    # onramp controller
    assert_difference 'Onboarding.count' do
      get survey_onramp_url(@onramp.token, uid: 'test')
    end
    @onboarding = Onboarding.where(onramp: @onramp).order(:created_at).last

    # pre_analyze step
    assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)

    follow_redirect! # => client survey
    assert_redirected_to @onboarding.survey_url_with_parameters
  end

  def run_post_survey_steps
    follow_redirect! # => post_analyze step
    follow_redirect! # => final_redirect step
  end
end
