# frozen_string_literal: true

require 'test_helper'

class InvitationDeliveryJobTest < ActiveJob::TestCase
  setup do
    survey = setup_live_survey

    @employee = employees(:operations)
    batch = sample_batches(:standard)
    batch.update!(survey: survey)
    @invitation = project_invitations(:standard)
    @invitation.update!(survey: survey, project: survey.project, batch: batch)
  end

  it 'sends a email via MadMimi' do
    MadMimi.any_instance.expects(:send_mail).with(instance_of(Hash), instance_of(Hash)).returns('s-573829')

    # assert_no_enqueued_jobs
    assert_nil @invitation.sent_at

    InvitationDeliveryJob.perform_now(@invitation, @employee)

    assert @invitation.sent_at
  end

  it 'is enqueued properly' do
    # assert_no_enqueued_jobs

    assert_enqueued_with(job: InvitationDeliveryJob) do
      InvitationDeliveryJob.perform_later(@invitation, @employee)
    end

    # assert_enqueued_jobs 2
  end

  it 'is not sent to an inactive panelist' do
    Panelist.any_instance.expects(:inactive?).returns(true)

    InvitationDeliveryJob.perform_now(@invitation, @employee)

    assert_nil @invitation.sent_at
  end

  it 'is not sent to a panelist with a birthdate error' do
    Panelist.any_instance.expects(:birthdate_error_exists?).returns(true)

    InvitationDeliveryJob.perform_now(@invitation, @employee)

    assert_nil @invitation.sent_at
  end

  it 'is not sent to a panelist with an invalid email' do
    Panelist.any_instance.expects(:email_invalid?).returns(true)

    InvitationDeliveryJob.perform_now(@invitation, @employee)

    assert_nil @invitation.sent_at
  end

  it 'retries if unsuccessful' do
    MadMimi.any_instance.expects(:send_mail).with(instance_of(Hash), instance_of(Hash)).returns('Authentication Failed.')

    # assert_no_enqueued_jobs

    InvitationDeliveryJob.perform_now(@invitation, @employee)

    # assert_enqueued_jobs 2
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
      InvitationDeliveryJob.perform_now(@invitation, @employee)
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

      InvitationDeliveryJob.perform_now(@invitation, @employee)
    end
  end
end
