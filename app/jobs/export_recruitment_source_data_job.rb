# frozen_string_literal: true

# export data for recruitment source report
class ExportRecruitmentSourceDataJob < ApplicationJob
  queue_as :ui

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def perform(current_user, start_period, end_period)
    @starting_at = Date.parse(start_period)
    @ending_at = Time.zone.parse(end_period).end_of_month

    data = RecruitmentSourceReportData.new(starting_at: @starting_at, ending_at: @ending_at)
    @affiliates = data.affiliates
    @nonprofits = data.nonprofits
    @others = data.others
    file = CSV.generate do |csv|
      csv << %w[Type ID Name ROI Completes Completers Panelists Signup Active Deactivated Donations]
      affiliates(csv)
      nonprofits(csv)
      others(csv)
    end
    ActionCable.server.broadcast(
      "recruitment_source_report_download_channel_#{current_user.id}",
      { csv_file: {
        file_name: 'recruitment_source_report.csv',
        content: file
      } }
    )
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  def affiliates(csv)
    @affiliates.each do |affiliate|
      csv << [
        'Affiliate',
        affiliate.code,
        affiliate.name,
        affiliate.roi_dollars,
        affiliate.completes,
        affiliate.completers,
        affiliate.total_panelists(starting_at: @starting_at, ending_at: @ending_at),
        affiliate.total_signup(starting_at: @starting_at, ending_at: @ending_at),
        affiliate.total_active(starting_at: @starting_at, ending_at: @ending_at),
        affiliate.total_deactivated(starting_at: @starting_at, ending_at: @ending_at),
        'n/a'
      ]
    end
    csv
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def nonprofits(csv)
    @nonprofits.each do |nonprofit|
      csv << [
        'Nonprofit',
        nonprofit.id,
        nonprofit.name,
        nonprofit.roi_dollars,
        nonprofit.completes,
        nonprofit.completers,
        nonprofit.total_panelists(starting_at: @starting_at, ending_at: @ending_at),
        nonprofit.total_signup(starting_at: @starting_at, ending_at: @ending_at),
        nonprofit.total_active(starting_at: @starting_at, ending_at: @ending_at),
        nonprofit.total_deactivated(starting_at: @starting_at, ending_at: @ending_at),
        nonprofit.total_donations(starting_at: @starting_at, ending_at: @ending_at)
      ]
    end
    csv
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def others(csv)
    @others.each do |others|
      csv << [
        'Others',
        others.id,
        others.name,
        others.roi_dollars,
        others.completes,
        others.completers,
        others.total_panelists(starting_at: @starting_at, ending_at: @ending_at),
        others.total_signup(starting_at: @starting_at, ending_at: @ending_at),
        others.total_active(starting_at: @starting_at, ending_at: @ending_at),
        others.total_deactivated(starting_at: @starting_at, ending_at: @ending_at),
        others.total_donations(starting_at: @starting_at, ending_at: @ending_at)
      ]
    end
    csv
  end
  # rubocop:enable Metrics/MethodLength
end
