# frozen_string_literal: true

# export data for affiliate report
class ExportAffiliateDataJob < ApplicationJob
  include AffiliateReportHelper
  queue_as :ui

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def perform(current_user, start_period, end_period)
    @records = AffiliateReportData.new(start_period: start_period, end_period: end_period).records
    file = CSV.generate do |csv|
      csv << ['Affiliate', 'Offer', 'TUNE signups', 'DB signups', 'Opportunities', 'Completes',
              'Completers', 'Affiliate payout', 'User payout', 'Total payout',  'Cost per complete']
      @records.each do |record|
        csv << [
          record.affiliate&.code_and_name,
          record.offer&.code_and_name,
          record.tune_signup_count,
          record.db_signup_count,
          record.opportunity_count,
          record.completes_count,
          record.completers_count,
          record.affiliate_payout,
          tune_signup_count(record),
          total_payout(record),
          cost_per_complete(record).round(2)
        ]
      end
    end
    ActionCable.server.broadcast(
      "affiliate_report_download_download_channel_#{current_user.id}",
      { csv_file: {
        file_name: 'affiliate_report.csv',
        content: file
      } }
    )
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
