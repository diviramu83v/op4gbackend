# frozen_string_literal: true

# Download active surveys report data.
class ActiveSurveysReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the active surveys report download channel.'
    stream_for current_user
    ExportActiveSurveysReportDataJob.perform_later(current_user)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the active surveys report download channel.'
  end
end
