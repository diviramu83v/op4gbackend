# frozen_string_literal: true

# Get created schlesinger_quota.
class CreateSchlesingerQuotaChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the create schlesinger quota channel.'
    stream_for 'all'
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the create schlesinger quota channel.'
  end
end
