# frozen_string_literal: true

# The job pulls the vendor block rate report data.
class PullVendorBlockRateReportDataJob < ApplicationJob
  queue_as :ui

  def perform(vendor_id, current_user)
    vendor = Vendor.find(vendor_id)
    pull_block_rate_report_data(vendor, current_user)
  end

  def pull_block_rate_report_data(vendor, current_user)
    @weeks = VendorBlockRateReportData.new(vendor: vendor).weekly_block_rate_totals_past_year
    html = ApplicationController.render(
      partial: 'employee/vendor_block_rate_reports/block_rate_report',
      locals: { vendor: vendor, weeks: @weeks }
    )

    ActionCable.server.broadcast(
      "vendor_block_rate_report_channel_#{current_user.id}",
      html
    )
  end
end
