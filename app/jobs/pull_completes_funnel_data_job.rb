# frozen_string_literal: true

# The job pulls the completes funnel data
class PullCompletesFunnelDataJob < ApplicationJob
  queue_as :ui

  def perform(resource, year, month)
    resource.pull_completes_funnel_data(year: year, month: month)
  end
end
