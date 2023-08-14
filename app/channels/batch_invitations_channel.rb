# frozen_string_literal: true

# Display invitation batch data when job is run
class BatchInvitationsChannel < ApplicationCable::Channel
  def subscribed
    sample_batch = SampleBatch.find(params[:sample_batch])
    stream_for sample_batch
    Rails.logger.debug { "Subscribed to the batch invitations channel. #{sample_batch.id}" }
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed to the batch invitations channel.'
    # Any cleanup needed when channel is unsubscribed
  end
end
