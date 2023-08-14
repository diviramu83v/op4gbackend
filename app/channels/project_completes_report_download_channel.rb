# frozen_string_literal: true

# Download project completes report data.
class ProjectCompletesReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the project completes report download channel.'
    stream_from "project_completes_report_download_channel_#{current_user.id}"
    ExportProjectCompletesReportDataJob.perform_async(current_user.id, params[:project_id])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the project completes report download channel.'
  end
end
