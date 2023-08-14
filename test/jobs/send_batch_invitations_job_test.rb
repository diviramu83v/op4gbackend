# frozen_string_literal: true

require 'test_helper'

class SendBatchInvitationsJobTest < ActiveJob::TestCase
  setup do
    @sample_batch = sample_batches(:standard)
  end

  it 'sets sent_at' do
    @sample_batch.update!(invitations_created_at: Time.current)
    @sample_batch.reload

    assert_nil @sample_batch.sent_at
    assert @sample_batch.startable?

    SendBatchInvitationsJob.perform_now(@sample_batch, Employee.first)
    @sample_batch.reload

    assert_not_nil @sample_batch.sent_at
  end

  it 'enqueues a job for every unsent invitation' do
    @sample_batch.update!(invitations_created_at: Time.current)

    assert_enqueued_jobs 1 do
      SendBatchInvitationsJob.perform_now(@sample_batch, Employee.first)
    end
  end

  describe 'batch groups' do
    setup do
      @sample_batch.update!(invitations_created_at: Time.current)
      @project = projects(:standard)
    end

    test 'sends invitations' do
      SendBatchInvitationsJob.perform_now(@sample_batch, Employee.first)
      @sample_batch.reload

      assert_not_nil @sample_batch.sent_at
    end

    test 'sends invitations with groups' do
      invitation = project_invitations(:standard)
      invitation.update(group: 2)

      @sample_batch.invitations.create!(
        project: projects(:standard),
        panelist: panelists(:active),
        survey: surveys(:standard),
        token: SecureRandom.hex,
        group: 5
      )

      SendBatchInvitationsJob.perform_now(@sample_batch, Employee.first)
      @sample_batch.reload

      assert_not_nil @sample_batch.sent_at
    end
  end
end
