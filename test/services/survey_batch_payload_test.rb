# frozen_string_literal: true

require 'test_helper'

class SurveyBatchPayloadTest < ActiveSupport::TestCase
  describe '#build' do
    setup do
      @token = mock
      @token2 = mock
    end

    it 'returns correct surveys' do
      @token.expects(:sandbox?).returns(false)
      assert_equal SurveyBatchPayload.build(@token), Survey.live.available_on_api
    end

    it 'returns correct surveys for sandbox' do
      @token2.expects(:sandbox?).returns(true)
      assert_equal SurveyBatchPayload.build(@token2), Survey.live.available_on_api_sandbox
    end
  end
end
