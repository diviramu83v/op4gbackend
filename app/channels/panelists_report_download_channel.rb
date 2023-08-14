# frozen_string_literal: true

# Download panelists report data.
class PanelistsReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the panelists report download channel.'
    stream_from "panelists_report_download_channel_#{current_user.id}"
    ExportPanelistsReportDataJob.perform_later(current_user)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the panelists report download channel.'
  end
end
