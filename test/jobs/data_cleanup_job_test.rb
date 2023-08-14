# frozen_string_literal: true

require 'test_helper'

class DataCleanupJobTest < ActiveJob::TestCase
  it 'passes the right message to the models that need to be cleaned up' do
    SystemEvent.expects(:summarize_and_delete_old_data).once
    ProjectInvitation.expects(:delete_stale_records).once
    Survey.expects(:delete_old_keys).once
    Survey.expects(:clean_stale_invitations).once

    DataCleanupJob.perform_now
  end
end
