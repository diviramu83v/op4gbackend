# frozen_string_literal: true

# Download block reasons report data.
class BlockReasonsReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the block reasons report download channel.'
    stream_for current_user
    ExportBlockReasonsReportJob.perform_later(current_user, params[:month], params[:year])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the block reasons report download channel.'
  end
end
