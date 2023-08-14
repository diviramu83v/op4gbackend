# frozen_string_literal: true

# export data for vendor performance report
class VendorPerformanceReportJob < ApplicationJob # rubocop:disable Metrics/ClassLength
  include ApplicationHelper
  queue_as :ui

  def perform(user:, client_id:, month:, year:, audience:, country_id:) # rubocop:disable Metrics:AbcSize
    @date = date(year, month)
    @client = Client.find_by(id: client_id)
    @country = Country.find_by(id: country_id)
    onboardings_hash = onboardings_grouped_by_vendor(audience)

    csv_file = CSV.generate do |csv|
      header(csv, audience)
      add_csv_rows(csv, onboardings_hash)
    end

    broadcast_to_channel(user, audience, csv_file)
  end

  private

  def date(year, month)
    DateTime.new(year.to_i, Date::MONTHNAMES.index(month))
  end

  def header(csv, audience)
    csv << ['Client', @client.name]
    csv << ['Audience', audience.presence || 'N/A']
    csv << ['Country', @country.present? ? @country.name : 'N/A']
    csv << []
    csv << ['Vendor', 'Completes', 'Rejected', 'Blocked', 'Fraudulent', 'Removal count', 'Removal %']
  end

  def onboardings_grouped_by_vendor(audience)
    client_onboardings = survey_onboardings(audience).joins(:client).where(client: { id: @client.id })

    sorted_vendor_onboardings_hash(client_onboardings)
  end

  def sorted_vendor_onboardings_hash(client_onboardings)
    vendors = client_onboardings.select(&:vendor).map(&:vendor).uniq
    hash = vendor_onboardings_count_hash(client_onboardings, vendors)
    hash.sort_by do |_, value|
      value = value.last
      value['complete_count'].to_i
    end.reverse
  end

  def vendor_onboardings_count_hash(client_onboardings, vendors) # rubocop:disable Metrics/AbcSize
    vendors.each_with_object({}) do |vendor, hash|
      onboardings = client_onboardings.joins(:batch_vendor).where(batch_vendor: { id: vendor.id })
      hash[vendor.name] = ['removal_count' => onboardings.complete.fraudulent.or(onboardings.complete.rejected).count,
                           'rejected_count' => onboardings.complete.rejected.count, 'blocked_count' => onboardings.blocked.count,
                           'fraudulent_count' => onboardings.complete.fraudulent.count, 'complete_count' => onboardings.complete.count]
    end
  end

  def file_name(audience)
    audience_name = "_for_#{audience}" if audience.present?
    country_name = "_in_#{@country.name}" if @country.present?

    "#{@client.name}_vendor_performance_report#{audience_name}#{country_name}_for_#{@date.strftime('%B')}_#{@date.strftime('%Y')}.csv"
  end

  def broadcast_to_channel(user, audience, csv_file)
    VendorPerformanceReportDownloadChannel.broadcast_to(
      user,
      csv_file: {
        file_name: file_name(audience),
        content: csv_file
      }
    )
  end

  def survey_onboardings(audience) # rubocop:disable Metrics/AbcSize
    if audience.present? && @country.present?
      Onboarding.where(created_at: @date.all_month).joins(:survey).where(surveys: { audience: audience, country_id: @country.id })
    elsif audience.present? && @country.blank?
      Onboarding.where(created_at: @date.all_month).joins(:survey).where(surveys: { audience: audience })
    elsif audience.blank? && @country.present?
      Onboarding.where(created_at: @date.all_month).joins(:survey).where(surveys: { country_id: @country.id })
    else
      Onboarding.where(created_at: @date.all_month)
    end
  end

  def csv_row(vendor_name, vendor_onboardings, csv)
    csv << [vendor_name, format_number(completes(vendor_onboardings)), format_number(rejected(vendor_onboardings)),
            format_number(blocked(vendor_onboardings)), format_number(fraudulent(vendor_onboardings)),
            format_number(removal_count(vendor_onboardings)), format_percentage(removal_percentage(vendor_onboardings))]
  end

  def completes(vendor_onboardings)
    vendor_onboardings = vendor_onboardings.first
    vendor_onboardings['complete_count']
  end

  def rejected(vendor_onboardings)
    vendor_onboardings = vendor_onboardings.first
    vendor_onboardings['rejected_count']
  end

  def blocked(vendor_onboardings)
    vendor_onboardings = vendor_onboardings.first
    vendor_onboardings['blocked_count']
  end

  def fraudulent(vendor_onboardings)
    vendor_onboardings = vendor_onboardings.first
    vendor_onboardings['fraudulent_count']
  end

  def removal_count(vendor_onboardings)
    vendor_onboardings = vendor_onboardings.first
    vendor_onboardings['removal_count']
  end

  def removal_percentage(vendor_onboardings)
    if (removal_count(vendor_onboardings) + completes(vendor_onboardings)).positive?
      removal_count(vendor_onboardings).fdiv(completes(vendor_onboardings)) * 100
    else
      0
    end
  end

  def add_csv_rows(csv, onboardings_hash)
    onboardings_hash.each do |vendor_name, vendor_onboardings|
      next if vendor_onboardings.blank?

      csv_row(vendor_name, vendor_onboardings, csv)
    end
  end
end
