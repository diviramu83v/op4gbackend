# frozen_string_literal: true

# View helpers for the affiliate report.
module AffiliateReportHelper
  def tune_signup_count(record)
    (record.db_signup_count || 0) * 2
  end

  def total_payout(record)
    (record.affiliate_payout || 0) + tune_signup_count(record)
  end

  def cost_per_complete(record)
    return 0 if record.completes_count.nil?

    total_payout(record) / record.completes_count
  end
end
