# frozen_string_literal: true

# export data for rejected disqo traffic
class DisqoRejectedTrafficReportChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the Disqo rejected traffic report download channel.'
    stream_for current_user
    DisqoRejectedTrafficReportJob.perform_later(params[:month], params[:year], current_user)
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the Disqo rejected traffic report download channel.'
  end
end
