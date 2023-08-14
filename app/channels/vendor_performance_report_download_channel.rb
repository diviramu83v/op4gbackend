# frozen_string_literal: true

# Download data for vendor performance report.
class VendorPerformanceReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the vendor performance report download channel.'
    stream_for current_user
    VendorPerformanceReportJob.perform_later(user: current_user, client_id: params[:client_id], month: params[:month], year: params[:year],
                                             audience: params[:audience], country_id: params[:country_id])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the vendor performance report download channel.'
  end
end
