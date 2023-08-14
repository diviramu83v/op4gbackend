# frozen_string_literal: true

# Download completes by vendor report.
class CompletesByVendorReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the completes by vendor report download channel.'
    stream_for current_user
    ExportCompletesByVendorReportJob.perform_later(current_user, params[:start_date], params[:end_date], params[:vendor])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the completes by vendor report download channel.'
  end
end
