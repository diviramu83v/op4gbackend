# frozen_string_literal: true

# Download panel completes report data.
class PanelCompletesBySourceDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the panel completes report download channel.'
    stream_for current_user
    ExportPanelCompletesBySourceReportJob.perform_later(current_user, params[:month], params[:year])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the panel completes report download channel.'
  end
end
