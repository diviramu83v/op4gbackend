# frozen_string_literal: true

# Stock Rails base class.
class ApplicationJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError

  retry_on RuntimeError, queue: :default, wait: :exponentially_longer, attempts: 20 do |job, error|
    message = "ApplicationJob attempted 20 times. class:#{job.class.name} error:#{error}"

    logger.error message
  end
end
