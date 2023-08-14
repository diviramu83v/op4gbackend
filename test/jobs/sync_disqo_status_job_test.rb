# frozen_string_literal: true

require 'test_helper'

class SyncDisqoStatusJobTest < ActiveJob::TestCase
  it 'should enqueue properly' do
    assert_no_enqueued_jobs
    assert_enqueued_with(job: SyncDisqoStatusJob) do
      SyncDisqoStatusJob.perform_later
    end
    assert_enqueued_jobs 1
  end
  describe 'check disqo quota status' do
    setup do
      @disqo_quota = disqo_quotas(:standard)
      @disqo_quota.update_column(:status, 'live') # rubocop:disable Rails/SkipsModelValidations
      DisqoApi.any_instance.stubs(:get_quota_status).returns('PAUSED')
      DisqoApi.any_instance.stubs(:change_project_quota_status).returns(nil)
      DisqoApi.any_instance.stubs(:update_project_status).returns(nil)
    end

    it 'should update a disqo quota status' do
      assert @disqo_quota.live?

      SyncDisqoStatusJob.perform_now

      @disqo_quota.reload
      assert @disqo_quota.paused?
    end
  end
end
