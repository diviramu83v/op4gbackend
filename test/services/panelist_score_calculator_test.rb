# frozen_string_literal: true

require 'test_helper'

class PanelistScoreCalculatorTest < ActiveSupport::TestCase
  describe '#calculate_score' do
    setup do
      @panelist = panelists(:standard)
      @panelist.expects(:recent_accepted_count).returns(5)
      @panelist.expects(:recent_rejected_count).returns(2)
      @panelist.expects(:recent_fraudulent_count).returns(1)
    end

    test 'score changes' do
      @panelist.update(score: nil)

      assert_changes -> { @panelist.score }, from: nil, to: 1 do
        PanelistScoreCalculator.new(panelist: @panelist).calculate!
      end
    end
  end

  describe '#calculate!' do
    setup do
      @panelist2 = panelists(:standard)
      @panelist2.expects(:recent_accepted_count).returns(5)
      @panelist2.expects(:recent_rejected_count).returns(2)
      @panelist2.expects(:recent_fraudulent_count).returns(1)

      PanelistScoreCalculator.new(panelist: @panelist2).calculate!

      @panelist2.suspended!
      @panelist2.update!(suspended_at: 8.months.ago)
    end

    test 'score does not change' do
      assert_no_changes -> { @panelist2.score } do
        PanelistScoreCalculator.new(panelist: @panelist2).calculate!
      end
    end
  end
end
