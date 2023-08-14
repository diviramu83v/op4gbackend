# frozen_string_literal: true

require 'test_helper'

class RecontactInvitationDeliveryJobTest < ActiveJob::TestCase
  setup do
    @employee = employees(:operations)
    @recontact_invitation = recontact_invitations(:standard)
  end

  it 'sets status from unsent to sent and sends an email via MadMimi' do
    MadMimi.any_instance.expects(:send_mail).with(instance_of(Hash), instance_of(Hash)).returns('s-573829')

    assert_equal 'unsent', @recontact_invitation.status

    RecontactInvitationDeliveryJob.perform_now(@recontact_invitation, Employee.first)

    assert_equal 'sent', @recontact_invitation.status
  end

  it 'is not sent to an inactive panelist' do
    Panelist.any_instance.expects(:inactive?).returns(true)

    RecontactInvitationDeliveryJob.perform_now(@recontact_invitation, @employee)

    assert_equal 'unsent', @recontact_invitation.status
  end

  it 'is not sent to a panelist with a birthdate error' do
    Panelist.any_instance.expects(:birthdate_error_exists?).returns(true)

    RecontactInvitationDeliveryJob.perform_now(@recontact_invitation, @employee)

    assert_equal 'unsent', @recontact_invitation.status
  end
end
