# frozen_string_literal: true

require 'test_helper'

class AffiliateDataReportTest < ActiveSupport::TestCase
  setup do
    starting = 30.days.ago.beginning_of_day.to_s
    ending = Time.now.utc.end_of_day.to_s

    @data = AffiliateReportData.new(
      start_period: starting,
      end_period: ending
    )
  end

  describe '#affiliates' do
    test 'returns affiliate data' do
      assert_equal 1, @data.records.count
    end
  end
end
