# frozen_string_literal: true

# Load traffic records data.
class TrafficDataChannel < ApplicationCable::Channel
  def subscribed
    survey = Survey.find(params[:survey_id])
    stream_for survey
    Rails.logger.debug 'Subscribed to the traffic data channel.'
    PullTrafficDataJob.perform_later(survey)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the traffic data channel.'
  end
end
