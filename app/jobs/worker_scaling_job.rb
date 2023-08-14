# frozen_string_literal: true

# Adjusts how many workers are running right now.
class WorkerScalingJob < ApplicationJob
  queue_as :default

  def perform
    worker_manager = WorkerManager.new
    worker_manager.scale
  rescue Excon::Error::ServiceUnavailable, Excon::Error::BadGateway => e
    Rails.logger.info "Error caught: #{e.message}"
  end
end
