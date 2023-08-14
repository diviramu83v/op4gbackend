# frozen_string_literal: true

require 'test_helper'

class RecruitmentSourceReportDataTest < ActiveSupport::TestCase
  setup do
    starting = 30.days.ago.beginning_of_day
    ending = Time.now.utc.end_of_day

    @data = RecruitmentSourceReportData.new(
      starting_at: starting,
      ending_at: ending
    )
  end

  describe '#affiliates' do
    test 'returns affiliate data' do
      assert_equal 1, @data.affiliates.count
    end
  end

  describe '#nonprofits' do
    test 'returns nonprofit data' do
      assert_equal 1, @data.nonprofits.count
    end
  end

  describe '#others' do
    test 'returns other data' do
      assert_equal 1, @data.others.count
    end
  end
end
