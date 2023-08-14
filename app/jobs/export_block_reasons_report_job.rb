# frozen_string_literal: true

# export data for block reasons report
class ExportBlockReasonsReportJob < ApplicationJob
  include ApplicationHelper
  queue_as :ui

  def perform(current_user, month, year) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    csv_file = CSV.generate do |csv|
      csv << ['Reason blocked', 'Count', '% of traffic']
      number_of_weeks = 8 # this param is editable for reports
      end_date = DateTime.new(year.to_i, Date::MONTHNAMES.index(month)).utc
      start_date = (end_date - number_of_weeks.weeks).beginning_of_day

      all_traffic_count = Onboarding.where(created_at: start_date..end_date).count
      blocked_traffic = Onboarding.blocked.where(created_at: start_date..end_date)

      count_hash = Hash.new(0)

      blocked_traffic.find_each do |onboarding|
        next if onboarding.error_message.blank?

        count_hash[onboarding.error_message] += 1
      end

      count_hash = count_hash.sort_by { |_k, v| -v }.to_h

      count_hash.each do |key, value|
        percentage = value / all_traffic_count.to_f

        csv << [key, format_number(value), format_percentage(percentage * 100)]
      end
    end

    BlockReasonsReportDownloadChannel.broadcast_to(
      current_user,
      csv_file: {
        file_name: "block_reasons_report_for_#{month}_#{year}.csv",
        content: csv_file
      }
    )
  end
end
