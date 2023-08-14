# frozen_string_literal: true

# Download recruitment source report data.
class RecruitmentSourceReportDownloadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the recruitment source report download channel.'
    stream_from "recruitment_source_report_download_channel_#{current_user.id}"
    ExportRecruitmentSourceDataJob.perform_later(current_user, params[:start_period], params[:end_period])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the recruitment source report download channel.'
  end
end
