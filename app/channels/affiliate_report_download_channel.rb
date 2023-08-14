# frozen_string_literal: true

# Download affiliate report data.
class AffiliateReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the affiliate report download channel.'
    stream_from "affiliate_report_download_download_channel_#{current_user.id}"
    ExportAffiliateDataJob.perform_later(current_user, params[:start_period], params[:end_period])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the affiliate report download channel.'
  end
end
