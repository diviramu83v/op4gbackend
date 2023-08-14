# frozen_string_literal: true

# The job that creates survey invitations.
class InvitationCreationJob < ApplicationJob
  queue_as :default

  def perform(sample_batch)
    sample_batch.create_invitations
  end
end
