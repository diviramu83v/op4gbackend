# frozen_string_literal: true

require 'test_helper'

class SyncSchlesingerStatusJobTest < ActiveSupport::TestCase
  describe 'enqueueing' do
    it 'is enqueued properly' do
      SyncSchlesingerStatusJob.perform_async
      assert_equal 'default', SyncSchlesingerStatusJob.queue
    end
  end

  describe 'check schlesinger quota status' do
    setup do
      Sidekiq::Testing.inline!
      @schlesinger_quota = schlesinger_quotas(:standard)
      @schlesinger_quota.update_column(:status, 'live') # rubocop:disable Rails/SkipsModelValidations
      SchlesingerApi.any_instance.stubs(:get_survey_status).returns(11)
    end

    it 'should update the schlesinger quota status' do
      assert @schlesinger_quota.live?

      SyncSchlesingerStatusJob.perform_async

      @schlesinger_quota.reload
      assert @schlesinger_quota.paused?
    end
  end
end
