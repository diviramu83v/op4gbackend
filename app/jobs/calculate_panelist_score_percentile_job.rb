# frozen_string_literal: true

# This job will calculate the score_percentile
class CalculatePanelistScorePercentileJob < ApplicationJob
  queue_as :default

  def perform
    PanelistScorePercentileCalculator.new.calculate!
  end
end
