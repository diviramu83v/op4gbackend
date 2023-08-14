# frozen_string_literal: true

# The job pulls the affiliate report data.
class PullAffiliateReportDataJob
  include Sidekiq::Worker
  sidekiq_options queue: 'ui'

  def perform(start_period, end_period, current_user_id)
    Affiliate.pull_report_data(start_period, end_period, current_user_id)
  end
end
