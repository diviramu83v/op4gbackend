# frozen_string_literal: true

# Download completes report data.
class CompletesReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the completes report download channel.'
    stream_for current_user
    ExportCompletesReportJob.perform_later(current_user, params[:report_type], params[:month], params[:year])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the completes report download channel.'
  end
end
