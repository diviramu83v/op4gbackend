# frozen_string_literal: true

require 'test_helper'

class DisqoUrlGeneratorTest < ActiveSupport::TestCase
  describe 'validation' do
    test 'requires onboarding to be non-nil' do
      assert_raises RuntimeError do
        DisqoUrlGenerator.new(onboarding: nil)
      end
    end
  end

  describe 'redirect_url' do
    setup do
      @key = Settings.disqo_hash_key
      @onboarding = onboardings(:complete)
      @response = @onboarding.survey_response_url
      @generator = DisqoUrlGenerator.new(onboarding: @onboarding)
      @onramp = @onboarding.onramp
      @onramp.update!(check_prescreener: false)
    end

    describe 'first case' do
      setup do
        @onboarding.save_disqo_params(
          clientId: Settings.disqo_username,
          projectId: '79162a',
          quotaIds: '["79162b"]',
          supplierId: '54637',
          tid: 'verifyTestTid',
          pid: 'verifyTestPid'
        )
      end

      test 'returns correct redirect_url' do
        passed_params = "clientId=#{Settings.disqo_username}&projectId=79162a&quotaIds=[\"79162b\"]&supplierId=54637&tid=verifyTestTid&pid=verifyTestPid"

        full_url = "#{Settings.disqo_redirect_url}?#{passed_params}&status=1"

        assert_equal "#{full_url}&auth=EhQpsYrJxdZSaGOeXdYUro2IgXg", @generator.redirect_url
      end
    end

    describe 'second case' do
      setup do
        @onboarding.save_disqo_params(
          clientId: Settings.disqo_username,
          projectId: '76785',
          quotaIds: '["76785"]',
          supplierId: '54637',
          tid: 'verifyTestTid',
          pid: 'verifyTestPid'
        )
      end

      test 'returns correct redirect_url' do
        passed_params = "clientId=#{Settings.disqo_username}&projectId=76785&quotaIds=[\"76785\"]&supplierId=54637&tid=verifyTestTid&pid=verifyTestPid"

        full_url = "#{Settings.disqo_redirect_url}?#{passed_params}&status=1"

        assert_equal "#{full_url}&auth=3iyrAY0bab530sj4jxlkP-MC3so", @generator.redirect_url
      end
    end
  end
end
