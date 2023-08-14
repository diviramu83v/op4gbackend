# frozen_string_literal: true

require 'test_helper'

class CacheSurveyPayloadJobTest < Minitest::Test
  describe 'cache survey payload' do
    before do
      Sidekiq::Testing.inline!
      @array = (1..5).to_a
    end

    it 'loops through the api tokens and caches payloads' do
      SurveyBatchPayload.expects(:build).times(ApiToken.count).returns(@array)
      SurveyPayload.expects(:build).times(@array.length * ApiToken.count).returns([nil, { some: 'payload_hash' }])
      CacheSurveyPayloadJob.perform_async
    end
  end
end
