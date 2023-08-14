# frozen_string_literal: true

# Upload for return keys
class ReturnKeyUploadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the return key upload channel.'
    survey = Survey.find(params[:survey_id])

    stream_for survey
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the return key upload channel.'
  end
end
