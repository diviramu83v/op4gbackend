# frozen_string_literal: true

# Handle subscriptions to system events.
class EventsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to events channel.'
    stream_from 'events:all'
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from events channel.'
    # Any cleanup needed when channel is unsubscribed
  end
end
