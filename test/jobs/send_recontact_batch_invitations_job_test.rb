# frozen_string_literal: true

require 'test_helper'

class SendRecontactBatchInvitationsJobTest < ActiveJob::TestCase
  setup do
    @batch = recontact_invitation_batches(:standard)
  end

  it 'sets status to send' do
    assert_equal 'initialized', @batch.status

    SendRecontactBatchInvitationsJob.perform_now(@batch, Employee.first)

    assert_equal 'sent', @batch.status
  end

  it 'enqueues a job' do
    @batch.update!(status: 'initialized')

    assert_enqueued_jobs 1 do
      SendRecontactBatchInvitationsJob.perform_now(@batch, Employee.first)
    end
  end
end
