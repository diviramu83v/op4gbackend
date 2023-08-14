# frozen_string_literal: true

# Handle sending all invitations for one recontact invitation batch.
class SendRecontactBatchInvitationsJob < ApplicationJob
  queue_as :default

  def perform(recontact_invitation_batch, current_employee)
    recontact_invitation_batch.recontact_invitations.unsent.find_each do |invitation|
      RecontactInvitationDeliveryJob.perform_later(invitation, current_employee)
    end

    recontact_invitation_batch.sent!
  end
end
