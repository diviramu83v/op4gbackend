# frozen_string_literal: true

# Get affiliate report data to system events.
class AffiliateReportChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the affiliate report channel.'
    stream_for current_user.id
    PullAffiliateReportDataJob.perform_async(params[:start_period], params[:end_period], current_user.id)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the affiliate report channel.'
  end
end
