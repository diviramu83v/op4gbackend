# frozen_string_literal: true

require 'test_helper'

class VendorBlockRateReportDataTest < ActiveSupport::TestCase
  setup do
    vendor = vendors(:batch)
    onramp = onramps(:vendor)
    onboarding = onboardings(:standard)
    onboarding.update(created_at: 2.months.ago)
    onboarding.blocked!
    onramp.onboardings << onboarding
    @weeks = VendorBlockRateReportData.new(vendor: vendor).weekly_block_rate_totals_past_year
  end

  describe '#weekly_block_rate_totals_past_year' do
    it 'returns vendor data' do
      assert @weeks.first['beginning_of_week'].to_date.monday?
      assert 1, @weeks.first['onboarding_count']
      assert 1, @weeks.first['blocked_onboarding_count']
    end
  end
end
