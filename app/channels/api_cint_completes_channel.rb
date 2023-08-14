# frozen_string_literal: true

# Download vendor block rate report data.
class ApiCintCompletesChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the API Cint completes channel.'
    years = params[:years]
    PullApiCintCompletesDataJob.perform_later(years)
    stream_for years
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the API Cint completes channel.'
  end
end
