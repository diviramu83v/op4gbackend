# frozen_string_literal: true

# Calculate the desired number of worker dynos based on the size of the job queue
class WorkerCalculator
  JOBS_TO_WORKERS = {
    0..299 => 1,
    300..1499 => 5,
    1500..100_000_000 => 10
  }.freeze

  def worker_count(job_count:)
    find_entry(job_count)[1]
  end

  private

  def find_entry(job_count)
    JOBS_TO_WORKERS.find do |range, _count|
      range.cover?(job_count)
    end
  end
end
