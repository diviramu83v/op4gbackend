# frozen_string_literal: true

# The purpose of this script is to reset the scores and score percentiles of panelists who were suspended over 6 months ago.
# Going forward, only active and suspended panelists, who were suspended less then 6 months ago, will have their score and score percentile calculated.

panelists = Panelist.suspended.where('suspended_at < ?', 6.months.ago)

panelists.each do |panelist|
  next if panelist.score.nil?

  # rubocop:disable Rails/SkipsModelValidations
  panelist.update_attribute(:score, nil)

  next if panelist.score_percentile.nil?

  panelist.update_attribute(:score_percentile, nil)
  # rubocop:enable Rails/SkipsModelValidations
end
