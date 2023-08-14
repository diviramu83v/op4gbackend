# frozen_string_literal: true

# A place to keep the specifics of talking/checking our worker queues.
#   Trying to keep the Sidekiq-specific syntax mostly in one place.
class JobQueueViewer
  def initialize(queue_name)
    @queue = Sidekiq::Queue.new(queue_name)
  end

  def size
    @queue.size
  end
end
