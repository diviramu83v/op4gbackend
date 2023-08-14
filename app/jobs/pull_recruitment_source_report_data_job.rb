# frozen_string_literal: true

# The job pulls the affiliate report data.
class PullRecruitmentSourceReportDataJob < ApplicationJob
  queue_as :ui

  # rubocop:disable Metrics/MethodLength
  def perform(start_period, end_period, current_user)
    @starting_at = Date.parse(start_period)
    @ending_at = Time.zone.parse(end_period).end_of_month

    data = RecruitmentSourceReportData.new(starting_at: @starting_at, ending_at: @ending_at)
    @affiliates = data.affiliates
    @nonprofits = data.nonprofits
    @others = data.others

    html = ApplicationController.render(
      partial: 'employee/recruitment_source_reports/table_data',
      locals: { affiliates: @affiliates, nonprofits: @nonprofits, others: @others, starting_at: @starting_at, ending_at: @ending_at }
    )

    RecruitmentSourceReportChannel.broadcast_to(current_user, html)
  end
  # rubocop:enable Metrics/MethodLength
end
