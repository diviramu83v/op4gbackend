# frozen_string_literal: true

# Handle subscriptions to system events.
class UidDecodingChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the uid decoding channel.'

    @decoding = Decoding.find(params[:id])

    UidDecodingJob.perform_later(@decoding)

    stream_for @decoding.id
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the uid decoding channel.'
  end
end
