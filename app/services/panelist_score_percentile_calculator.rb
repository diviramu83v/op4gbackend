# frozen_string_literal: true

# this calculates the panelist's score percentile
class PanelistScorePercentileCalculator
  def initialize
    @panelists = Panelist.scored
  end

  # rubocop:disable Rails/SkipsModelValidations
  def calculate!
    @panelists.find_each do |panelist|
      panelist.update_columns(score_percentile: calculate_score_percentile(panelist))
    end
  end
  # rubocop:enable Rails/SkipsModelValidations

  private

  def calculate_score_percentile(panelist)
    percentile = (total_with_lower_score(panelist) / total_with_score.to_f) * 100
    percentile.floor
  end

  def total_with_score
    @total_with_score ||= Panelist.scored.count
  end

  def total_with_lower_score(panelist)
    Panelist.scored.where('score < ?', panelist.score).count
  end
end
