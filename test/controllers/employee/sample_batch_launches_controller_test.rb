# frozen_string_literal: true

require 'test_helper'

class Employee::SampleBatchLaunchesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    sign_in employees(:operations)
  end

  it 'launch sample batch' do
    @sample_batch = sample_batches(:standard)

    assert_not_empty @sample_batch.invitations

    @sample_batch.survey.live!
    @sample_batch.update!(invitations_created_at: Time.now.utc)
    @sample_batch.invitations.update(sent_at: nil)

    # assert_no_enqueued_jobs
    assert_enqueued_with(job: SendBatchInvitationsJob) do
      post sample_batch_launch_url(@sample_batch)
    end
    # assert_enqueued_jobs 1
  end

  it 'fail to launch sample batch' do
    SampleBatch.any_instance.stubs(:send_invitations).returns(false)

    @sample_batch = sample_batches(:standard)

    assert_not_empty @sample_batch.invitations

    assert_no_enqueued_jobs do
      post sample_batch_launch_url(@sample_batch)
    end
  end
end
