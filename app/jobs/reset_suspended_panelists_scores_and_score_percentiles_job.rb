# frozen_string_literal: true

# This job resets the scores and score_percentiles to nil of panelists who were suspended over 6 months ago.
class ResetSuspendedPanelistsScoresAndScorePercentilesJob < ApplicationJob
  queue_as :default

  def perform
    reset_scores_and_score_percentiles
  end

  private

  # rubocop:disable Rails/SkipsModelValidations
  def reset_scores_and_score_percentiles
    panelists = Panelist.suspended.where('suspended_at < ?', 6.months.ago)

    panelists.each do |panelist|
      next if panelist.score.nil?

      panelist.update_attribute(:score, nil)

      next if panelist.score_percentile.nil?

      panelist.update_attribute(:score_percentile, nil)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
