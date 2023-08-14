# frozen_string_literal: true

require 'test_helper'

class FinalUrlRedirectTest < ActiveSupport::TestCase
  describe '#final_url' do
    setup do
      @onboarding = onboardings(:standard)
      @final_url_redirect = FinalUrlRedirect.new(onboarding: @onboarding)
    end

    it 'hits the final_redirect_url' do
      @onboarding.update!(onramp: onramps(:vendor), survey_response_url: survey_response_urls(:complete))

      assert_equal @final_url_redirect.final_url, 'https://batch.vendor.com/complete?uid=123'
    end

    it 'hits the disqo_redirect_url complete route' do
      @onboarding.update!(onramp: onramps(:disqo), survey_response_pattern: survey_response_patterns(:complete))
      @response = @onboarding.survey_response_url
      DisqoUrlGenerator.any_instance.expects(:redirect_url).returns('https://generator.com?uid=123')

      assert_equal 'https://generator.com?uid=123', @final_url_redirect.final_url
    end

    it 'hits the cint_redirect_url complete route' do
      stub_request(:post, "#{Settings.cint_api_url}/fulfillment/respondents/transition").to_return(status: 200)
      @onboarding.update!(onramp: onramps(:cint), survey_response_url: survey_response_urls(:complete))

      assert_equal "#{Settings.cint_redirect_url}/123", @final_url_redirect.final_url
    end

    it 'hits the schlesinger_redirect_url complete route' do
      @onboarding.update(api_params: { 'pid' => '123' })
      @onboarding.update!(onramp: onramps(:schlesinger), survey_response_url: survey_response_urls(:complete))

      assert_equal "#{Settings.schlesinger_redirect_url}?RS=1&RID=123&hash=50XI-1a_j3oSlsX4mcZqWokCyI4", @final_url_redirect.final_url
    end

    it 'hits the fallback_redirect_url security route' do
      assert_equal @final_url_redirect.final_url, "http://survey.op4g.local:3000/security?onboarding_id=#{@onboarding.id}"
    end

    it 'hits the fallback_redirect_url complete route' do
      @onboarding.update!(survey_response_url: survey_response_urls(:complete))
      assert_equal @final_url_redirect.final_url, "http://survey.op4g.local:3000/complete?sid=#{@onboarding.project.id}&token=#{@onboarding.response_token}"
    end

    it 'hits the fallback_redirect_url terminate route' do
      @onboarding.update!(survey_response_url: survey_response_urls(:terminate))
      assert_equal @final_url_redirect.final_url, "http://survey.op4g.local:3000/screened?sid=#{@onboarding.project.id}&token=#{@onboarding.response_token}"
    end

    it 'hits the fallback_redirect_url quotafull route' do
      @onboarding.update!(survey_response_url: survey_response_urls(:quotafull))
      assert_equal @final_url_redirect.final_url, "http://survey.op4g.local:3000/full?sid=#{@onboarding.project.id}&token=#{@onboarding.response_token}"
    end
  end

  describe '#failed_traffic_steps_url' do
    setup do
      @onboarding = onboardings(:standard)
      Survey.any_instance.expects(:uses_return_keys?).returns(false)
      @final_url_redirect = FinalUrlRedirect.new(onboarding: @onboarding)
    end

    it 'hits the vendor_batch security_url' do
      @onboarding.update!(onramp: onramps(:vendor))
      assert_equal @final_url_redirect.failed_traffic_steps_url, 'https://batch.vendor.com/security?uid=123'
    end

    it 'hits the vendor_batch terminate_url' do
      @onboarding.update!(onramp: onramps(:vendor))
      @onboarding.vendor_batch.update!(security_url: nil)
      @onboarding.vendor.update!(security_url: nil)
      @onboarding.reload
      assert_equal @final_url_redirect.failed_traffic_steps_url, 'https://batch.vendor.com/term?uid=123'
    end

    # rubocop:disable Rails/SkipsModelValidations
    it 'hits the survey_security_errors_url' do
      @onboarding.update!(onramp: onramps(:vendor))
      @onboarding.vendor_batch.update!(security_url: nil, terminate_url: nil)
      @onboarding.vendor.update_columns(security_url: nil, terminate_url: nil)
      @onboarding.reload
      assert_equal @final_url_redirect.failed_traffic_steps_url, "http://survey.op4g.local:3000/security?onboarding_id=#{@onboarding.id}"
    end
    # rubocop:enable Rails/SkipsModelValidations
  end

  test 'DISQO traffic that fails security' do
    @onboarding = onboardings(:standard)
    @final_url_redirect = FinalUrlRedirect.new(onboarding: @onboarding)
    @onboarding.update!(onramp: onramps(:disqo), survey_response_pattern: nil)
    @onboarding.save_disqo_params(
      clientId: Settings.disqo_username,
      projectId: '79162a',
      quotaIds: '["79162b"]',
      supplierId: '54637',
      tid: 'verifyTestTid',
      pid: 'verifyTestPid'
    )

    passed_params = "clientId=#{Settings.disqo_username}&projectId=79162a&quotaIds=[\"79162b\"]&supplierId=54637&tid=verifyTestTid&pid=verifyTestPid"

    full_url = "#{Settings.disqo_redirect_url}?#{passed_params}&status=4"

    assert_equal "#{full_url}&auth=nl7wtRwaGjc6WXeWV5isKcioSs8", @final_url_redirect.failed_traffic_steps_url
  end
end
