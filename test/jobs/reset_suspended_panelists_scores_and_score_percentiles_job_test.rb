# frozen_string_literal: true

require 'test_helper'

class ResetSuspendedPanelistsScoresAndScorePercentilesJobTest < ActiveJob::TestCase
  setup do
    @panelist = panelists(:standard)
    @panelist.update(score: 5, score_percentile: 40)
    @panelist.suspend
  end

  test 'set score and score_percenitle to nil if panelist suspended over 6 months ago' do
    @panelist.update(suspended_at: 6.months.ago)

    assert @panelist.score, 5
    assert @panelist.score_percentile, 40

    ResetSuspendedPanelistsScoresAndScorePercentilesJob.perform_now

    assert @panelist.score, nil
    assert @panelist.score_percentile, nil
  end

  test 'do not set score and score_percenitle to nil if panelist suspended less then 6 months ago' do
    @panelist.update(suspended_at: 1.month.ago)

    assert @panelist.score, 5
    assert @panelist.score_percentile, 40

    ResetSuspendedPanelistsScoresAndScorePercentilesJob.perform_now

    assert @panelist.score, 5
    assert @panelist.score_percentile, 40
  end
end
