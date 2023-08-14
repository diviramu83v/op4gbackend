# frozen_string_literal: true

# Download vendor block rate report data.
class ApiDisqoCompletesChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the API Disqo completes channel.'
    years = params[:years]
    PullApiDisqoCompletesDataJob.perform_later(years)
    stream_for years
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the API Disqo completes channel.'
  end
end
