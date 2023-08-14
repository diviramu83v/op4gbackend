# frozen_string_literal: true

# This calculates the Panelist.score by subtracting the fraudulent count
# from the accepted count over the past 18 months.
class PanelistScoreCalculator
  def initialize(panelist:)
    @panelist = panelist
  end

  # rubocop:disable Rails/SkipsModelValidations
  def calculate!
    return unless @panelist
    return unless @panelist.active? || (@panelist.suspended? && @panelist.suspended_at.present? && @panelist.suspended_at >= 6.months.ago)

    @panelist.update_columns(score: calculate_score)
  end
  # rubocop:enable Rails/SkipsModelValidations

  private

  def calculate_score
    @panelist.recent_accepted_count -
      @panelist.recent_rejected_count -
      (@panelist.recent_fraudulent_count * 2)
  end
end
