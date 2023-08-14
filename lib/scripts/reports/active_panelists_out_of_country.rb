# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/active_panelists_out_of_country.rb > ~/Downloads/active_panelists_out_of_country_report.csv

include ApplicationHelper

start_time = Time.now.utc

puts 'Date & Time Created, Email, Status, Panel, Country'

panelists = Panelist.signing_up_or_active.where(status: 'active')
count = 0

panelists.most_recent_first.find_each do |panelist|
  next if panelist.clean_id_data.blank?

  data = panelist.clean_id_data
  data.is_a?(String) ? {} : data
  country = data.dig('forensic', 'geo', 'countryCode')

  next if country.downcase == panelist.primary_panel.country.slug.downcase || (country == 'GB' && panelist.primary_panel.country.slug == 'uk')

  date_created = panelist.created_at
  email = panelist.email
  status = panelist.status
  panel = panelist.primary_panel.slug
  count += 1

  puts "\"#{date_created.strftime('%-m/%-d/%Y at %r')}\",\"#{email}\",\"#{status}\",\"#{panel}\",\"#{country}\""
  next
end

puts
puts "\"Total Panelists Out of Country : #{format_number(count)}\""
puts
puts "Report Generated on #{Time.now.utc.strftime('%-m/%-d/%Y at %r')}"
puts "Completed in #{(Time.now.utc - start_time).to_i} second(s)"
