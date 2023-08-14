# frozen_string_literal: true

# Coordinates Sidekiq and Heroku data to scale workers appropriately.
class WorkerManager
  def initialize
    @sidekiq = SidekiqManager.new
    @heroku = HerokuManager.new
    @worker_calculator = WorkerCalculator.new
  end

  def scale
    return unless needs_scaling?
    return if scaling_down? && workers_busy?

    Rails.logger.info "scaling worker count from #{current_worker_count} to #{new_worker_count}..."

    @heroku.scale_workers(worker_count: new_worker_count)
  end

  private

  def job_count
    @job_count ||= @sidekiq.job_count
  end

  def current_worker_count
    @current_worker_count ||= @heroku.worker_count
  end

  def new_worker_count
    @new_worker_count ||= @worker_calculator.worker_count(job_count: job_count)
  end

  def needs_scaling?
    new_worker_count != current_worker_count
  end

  def scaling_down?
    new_worker_count < current_worker_count
  end

  def workers_busy?
    @sidekiq.busy_workers?
  end
end
