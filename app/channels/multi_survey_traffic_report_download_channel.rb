# frozen_string_literal: true

# Download multi-survey traffic report data.
class MultiSurveyTrafficReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the multi-survey traffic report download channel.'
    stream_from "multi_survey_traffic_report_download_channel_#{current_user.id}"
    ExportMultiSurveyTrafficReportDataJob.perform_async(current_user.id, params[:survey_ids], params[:report_type])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the multi-survey traffic report download channel.'
  end
end
