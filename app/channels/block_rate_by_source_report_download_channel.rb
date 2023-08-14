# frozen_string_literal: true

# Download block rate by source report.
class BlockRateBySourceReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the block rate by source report download channel.'
    stream_for current_user
    ExportBlockRateBySourceReportJob.perform_later(current_user, params)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the block rate by source report download channel.'
  end
end
