# frozen_string_literal: true

# Compile the data necessary for the vendor block rate report.
class VendorBlockRateReportData
  def initialize(vendor:)
    @vendor = vendor
  end

  def weekly_block_rate_totals_past_year # rubocop:disable Metrics/MethodLength
    # sql was used in order to speed up the query
    sql = <<-SQL.squish
      SELECT date_trunc('week', onboardings.created_at) AS beginning_of_week,
             count(*) AS onboarding_count,
             count(*) FILTER (WHERE onboardings.status = 'blocked') AS blocked_onboarding_count
      FROM onboardings
      INNER JOIN onramps ON onboardings.onramp_id = onramps.id
      INNER JOIN vendor_batches ON onramps.vendor_batch_id = vendor_batches.id
      WHERE vendor_batches.vendor_id = #{@vendor.id}
        AND onboardings.created_at > '#{1.year.ago}'
      GROUP BY beginning_of_week
      ORDER BY beginning_of_week DESC
    SQL

    ActiveRecord::Base.connection.exec_query(sql)
  end
end
