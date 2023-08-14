# frozen_string_literal: true

require 'test_helper'

class ReminderDeliveryJobTest < ActiveJob::TestCase
  setup do
    @employee = employees(:operations)
    @sample_batch = sample_batches(:standard)
    @invitation = project_invitations(:standard)

    @invitation.update!(sent_at: Time.now.utc, status: 'sent')
  end

  it 'is enqueued properly' do
    assert_enqueued_with(job: ReminderDeliveryJob) do
      ReminderDeliveryJob.perform_later(@invitation, @employee)
    end
  end

  it 'sends reminders for a sample batch' do
    MadMimi.any_instance.expects(:send_mail).with(instance_of(Hash), instance_of(Hash)).returns('s-573829')

    assert_not_empty @sample_batch.remindable_invitations

    ReminderDeliveryJob.perform_now(@invitation, @employee)
    @sample_batch.reload

    assert_empty @sample_batch.remindable_invitations
  end

  it 'marks batch as reminded' do
    MadMimi.any_instance.expects(:send_mail).with(instance_of(Hash), instance_of(Hash)).returns('s-573829')

    assert_not @sample_batch.reminders_sent?

    ReminderDeliveryJob.perform_now(@invitation, @employee)
    @sample_batch.reload

    assert @sample_batch.reminders_sent?
  end

  it 'is not sent to an inactive panelist' do
    Panelist.any_instance.expects(:inactive?).returns(true)

    ReminderDeliveryJob.perform_now(@invitation, @employee)

    assert_nil @invitation.reminded_at
  end

  it 'retries if unsuccessful' do
    MadMimi.any_instance.expects(:send_mail).with(instance_of(Hash), instance_of(Hash)).returns('Authentication Failed.')

    # assert_no_enqueued_jobs

    ReminderDeliveryJob.perform_now(@invitation, @employee)

    # assert_enqueued_jobs 1
  end

  describe 'email delivery turned off' do
    setup do
      MadMimiMailer.any_instance
                   .expects(:allow_real_emails?)
                   .returns(false)
                   .once
    end

    it 'sends email to employee email address' do
      MadMimi.any_instance
             .expects(:send_mail)
             .with(has_entry(recipients: @employee.email), Not(includes(nil)))
      ReminderDeliveryJob.perform_now(@invitation, @employee)
    end
  end

  describe 'email delivery turned on' do
    setup do
      MadMimiMailer.any_instance
                   .expects(:allow_real_emails?)
                   .returns(true)
                   .once
    end

    it 'sends email to panelist email address' do
      MadMimi.any_instance
             .expects(:send_mail)
             .with(has_entry(recipients: @invitation.panelist.email), Not(includes(nil)))
      ReminderDeliveryJob.perform_now(@invitation, @employee)
    end
  end
end
