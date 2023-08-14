# frozen_string_literal: true

require 'test_helper'

class CreateTangoOrdersJobTest < ActiveJob::TestCase
  setup do
    @incentive_batch = incentive_batches(:standard)
    @incentive_recipient = incentive_recipients(:standard)
  end

  test 'is enqueued' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: CreateTangoOrdersJob) do
      CreateTangoOrdersJob.perform_later(@incentive_batch)
    end

    assert_enqueued_jobs 1
  end

  test 'returns error' do
    stub_request(:post, 'https://integration-api.tangocard.com/raas/v2/orders').to_return(status: 200)

    CreateTangoOrdersJob.perform_now(@incentive_batch)
    @incentive_batch.reload
    assert_equal 'error', @incentive_batch.incentive_recipients.first.status
  end
end
