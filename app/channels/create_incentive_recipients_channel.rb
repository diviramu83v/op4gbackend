# frozen_string_literal: true

# Get create incentive recipients
class CreateIncentiveRecipientsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the create incentive recipients channel.'

    stream_for 'all'
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the create incentive recipients channel.'
  end
end
