# frozen_string_literal: true

# Handle subscriptions to system events.
class ProjectReportsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to project reports channel.'

    stream_for 'all'
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from project reports channel.'
  end
end
