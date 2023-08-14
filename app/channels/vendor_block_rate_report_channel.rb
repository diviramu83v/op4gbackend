# frozen_string_literal: true

# Download vendor block rate report data.
class VendorBlockRateReportChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the vendor block rate report channel.'
    stream_from "vendor_block_rate_report_channel_#{current_user.id}"
    PullVendorBlockRateReportDataJob.perform_later(params[:vendor_id], current_user)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the vendor block rate report channel.'
  end
end
