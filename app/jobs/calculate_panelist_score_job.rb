# frozen_string_literal: true

# This job will calculate the score
class CalculatePanelistScoreJob < ApplicationJob
  queue_as :default

  def perform(panelist:)
    PanelistScoreCalculator.new(panelist: panelist).calculate!
  end
end
