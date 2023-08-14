# frozen_string_literal: true

# Usage: rails runner lib/scripts/suspend_pre_survey_out_of_country_panelists.rb

include ApplicationHelper

end_date = Time.now.utc
start_date = Time.now.utc - 180.days

start_time = Time.now.utc

traffic_checks = TrafficCheck.order(id: :desc)
                             .where.not(data_collected: nil)
                             .where(controller_action: 'show')
                             .where('created_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)

panelist_ids = []

traffic_checks.find_each do |traffic|
  onboarding = traffic.onboarding

  next if onboarding.blank? || onboarding.panelist.blank? || onboarding.panelist.primary_panel.blank?

  panelist = onboarding.panelist

  next unless panelist.active?

  clean_id_data_locator = OnboardingCleanIdData.new(onboarding: onboarding)

  clean_id_data = clean_id_data_locator.pre_survey_clean_id_data

  next if clean_id_data.is_a?(String) || clean_id_data.blank?

  country = clean_id_data.dig('forensic', 'geo', 'countryCode')

  next if country.blank? || country.downcase == panelist.primary_panel.country.slug.downcase
  next if country == 'GB' && panelist.primary_panel.country.slug.downcase == 'uk'

  panelist.update!(
    suspended_at: Time.now.utc,
    status: Panelist.statuses[:suspended]
  )

  panelist.notes.create!(employee_id: 0, body: "Automatically suspended: CleanID country doesn't match the panel's country.")

  panelist_ids << panelist.id
rescue ActiveRecord::RecordInvalid
  # rubocop:disable Rails/SkipsModelValidations
  panelist.update_columns(
    suspended_at: Time.now.utc,
    status: Panelist.statuses[:suspended]
  )
  # rubocop:enable Rails/SkipsModelValidations

  panelist.notes.create!(employee_id: 0, body: "Automatically suspended: CleanID country doesn't match the panel's country.")

  panelist_ids << panelist.id
end

puts
puts "Date Range: #{start_date.to_date.strftime('%B %d, %Y')} to #{end_date.to_date.strftime('%B %d, %Y')}"
puts "Total Panelists Suspended = #{format_number(panelist_ids.uniq.count)}"
puts "Completed in #{(Time.now.utc - start_time).to_i} second(s)"
