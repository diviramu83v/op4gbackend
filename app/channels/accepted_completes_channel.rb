# frozen_string_literal: true

# Download accepted completes data.
class AcceptedCompletesChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the accepted completes channel.'
    decoding = CompletesDecoder.find(params[:decoding_id])
    project = Project.find(params[:project_id])
    PullAcceptedCompletesDataJob.perform_later(decoding, project)
    stream_for decoding
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the accepted completes channel.'
  end
end
