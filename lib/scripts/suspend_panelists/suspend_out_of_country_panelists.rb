# frozen_string_literal: true

# Usage: rails runner lib/scripts/suspend_out_of_country_panelists.rb

include ApplicationHelper

start_time = Time.now.utc

panelists = Panelist.active
count = 0

panelists.find_each do |panelist|
  next if panelist.clean_id_data.blank?

  data = panelist.clean_id_data
  country = data.dig('forensic', 'geo', 'countryCode')

  next if country.blank?

  next if country.downcase == panelist.primary_panel.country.slug.downcase
  next if country == 'GB' && panelist.primary_panel.country.slug == 'uk'

  panelist.update!(
    suspended_at: Time.now.utc,
    status: Panelist.statuses[:suspended]
  )

  panelist.notes.create!(employee_id: 0, body: "Automatically suspended: CleanID country doesn't match the panel's country.")

  count += 1
rescue ActiveRecord::RecordInvalid
  # rubocop:disable Rails/SkipsModelValidations
  panelist.update_columns(
    suspended_at: Time.now.utc,
    status: Panelist.statuses[:suspended]
  )
  # rubocop:enable Rails/SkipsModelValidations

  panelist.notes.create!(employee_id: 0, body: "Automatically suspended: CleanID country doesn't match the panel's country.")

  count += 1
end

puts "Total Panelists Suspended = #{format_number(count)}"
puts "Completed in #{(Time.now.utc - start_time).to_i} second(s)"
