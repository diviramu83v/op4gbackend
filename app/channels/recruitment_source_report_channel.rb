# frozen_string_literal: true

# Get recruitment source report data to system events.
class RecruitmentSourceReportChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the recruitment source report channel.'
    stream_for current_user
    PullRecruitmentSourceReportDataJob.perform_later(params[:start_period], params[:end_period], current_user)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the recruitment source report channel.'
  end
end
