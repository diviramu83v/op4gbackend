# frozen_string_literal: true

# export data for completes report
class ExportCompletesReportJob < ApplicationJob
  include ApplicationHelper
  queue_as :ui

  def perform(current_user, report_type, month, year)
    @date = date(year, month)
    @report_type = report_type
    csv_file = CSV.generate do |csv|
      current_month_onboardings_hash.each do |client_status, count_hash|
        next if count_hash.blank?

        csv << header(client_status)
        add_csv_rows(csv, count_hash, client_status)
      end
    end

    broadcast_to_channel(current_user, csv_file)
  end

  private

  def add_csv_rows(csv, count_hash, client_status)
    count_hash.each do |traffic_source, count|
      csv << csv_row(traffic_source, count, client_status)
    end
  end

  def csv_row(traffic_source, count, client_status)
    [traffic_source, format_number(count), format_percentage(current_share(count, client_status)),
     format_percentage(change_in_share(traffic_source, count, client_status))]
  end

  def change_in_share(traffic_source, count, client_status)
    current_share(count, client_status) - previous_share(traffic_source, client_status)
  end

  def previous_share(traffic_source, client_status)
    (previous_month_onboardings_hash[client_status][traffic_source].to_f / previous_month_onboardings.where(client_status: client_status).size) * 100
  end

  def current_share(count, client_status)
    (count.to_f / selected_month_onboardings.where(client_status: client_status).size) * 100
  end

  def current_month_onboardings_hash
    month_onboardings_hash(selected_month_onboardings)
  end

  def previous_month_onboardings_hash
    @previous_month_onboardings_hash ||= month_onboardings_hash(previous_month_onboardings)
  end

  def selected_month_onboardings
    @selected_month_onboardings ||= onboardings_for_type_and_date(@date)
  end

  def previous_month_onboardings
    @previous_month_onboardings ||= onboardings_for_type_and_date(@date.last_month)
  end

  def broadcast_to_channel(current_user, csv_file)
    CompletesReportDownloadChannel.broadcast_to(
      current_user,
      csv_file: {
        file_name: "#{@report_type}_completes_report_for_#{@date.strftime('%B')}_#{@date.strftime('%Y')}.csv",
        content: csv_file
      }
    )
  end

  def date(year, month)
    DateTime.new(year.to_i, Date::MONTHNAMES.index(month)).utc
  end

  def header(client_status)
    ['Source', "#{client_status.capitalize} count", "#{client_status.capitalize} current share", "#{client_status.capitalize} change in share"]
  end

  def month_onboardings_hash(onboardings)
    Onboarding.client_statuses.values.index_with do |client_status|
      onboardings.where(client_status: client_status).map { |onboarding| source_name(onboarding) }.tally.sort_by { |_k, v| v }.reverse.to_h
    end
  end

  def onboardings_for_type_and_date(date)
    onboardings = Onboarding.complete.where(created_at: date.all_month)
    return onboardings if @report_type == 'Select all'

    onboardings.complete.where(client_status: @report_type.downcase)
  end

  def source_name(onboarding)
    return 'Disqo' if onboarding.source_name.include?('Disqo')
    return 'Cint' if onboarding.source_name.include?('Cint')

    onboarding.source_name
  end
end
