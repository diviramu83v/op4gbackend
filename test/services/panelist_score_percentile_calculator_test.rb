# frozen_string_literal: true

require 'test_helper'

class PanelistScorePercentileCalculatorTest < ActiveSupport::TestCase
  describe '#calculate!' do
    setup do
      @panelist = panelists(:standard)
      @second_panelist = panelists(:active)
    end

    test 'percentile set' do
      @panelist.update!(score: 50, score_percentile: nil)

      assert_changes -> { @panelist.reload.score_percentile } do
        PanelistScorePercentileCalculator.new.calculate!
      end
    end

    test 'percentile changes' do
      @panelist.update!(score: 50, score_percentile: 99)
      @second_panelist.update!(score: 100, score_percentile: 99)

      assert_changes -> { [@panelist.reload.score_percentile, @second_panelist.reload.score_percentile] } do
        PanelistScorePercentileCalculator.new.calculate!
      end
    end
  end
end
