# frozen_string_literal: true

require 'test_helper'

class SampleBatchReminderJobTest < ActiveJob::TestCase
  setup do
    @employee = employees(:operations)
    @sample_batch = sample_batches(:standard)
    @sample_batch.invitations.each { |invitation| invitation.update!(sent_at: Time.now.utc, status: 'sent') }
  end

  it 'is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: SampleBatchReminderJob) do
      SampleBatchReminderJob.perform_later(@sample_batch, @employee)
    end

    assert_enqueued_jobs 1
  end

  it 'enqueues ReminderDeliverJob' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: ReminderDeliveryJob) do
      SampleBatchReminderJob.perform_now(@sample_batch, @employee)
    end

    assert_enqueued_jobs 1
  end
end
