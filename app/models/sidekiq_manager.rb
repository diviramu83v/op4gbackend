# frozen_string_literal: true

# Abstract the calls to Sidekiq.
class SidekiqManager
  def initialize
    @processes = Sidekiq::ProcessSet.new
    @stats = Sidekiq::Stats.new
  end

  def busy_workers?
    busy_worker_processes.positive?
  end

  def job_count
    @stats.enqueued + @stats.retry_size
  end

  private

  # process['busy']: a count of the busy threads in each process
  def busy_worker_processes
    @processes.count do |process|
      process['busy'].to_i.positive?
    end
  end
end
