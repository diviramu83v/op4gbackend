# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/average_panelist_lifespan.rb > ~/Downloads/average_panelist_lifespan_report.csv

include ApplicationHelper

start_time = Time.now.utc

active_panelists = Panelist.active

deactivated_panelists = Panelist.deactivated.where.not(deactivated_at: nil)

suspended_panelists = Panelist.suspended.where.not(suspended_at: nil)

deleted_panelists = Panelist.deleted.where.not(deleted_at: nil)

one_year = 1.year.to_i

active_years = active_panelists.map { |panelist| (Time.now.utc - panelist.created_at) / one_year }.sum

deactivated_years = deactivated_panelists.map { |panelist| (panelist.deactivated_at - panelist.created_at) / one_year }.sum

suspended_years = suspended_panelists.map { |panelist| (panelist.suspended_at - panelist.created_at) / one_year }.sum

deleted_years = deleted_panelists.map { |panelist| (panelist.deleted_at - panelist.created_at) / one_year }.sum

total_years = active_years + deactivated_years + suspended_years + deleted_years

total_panelists = active_panelists.count + deactivated_panelists.count + suspended_panelists.count + deleted_panelists.count

average_panelist_lifespan = total_years / total_panelists

puts 'Average Panelist Lifespan Report'
puts "\"Total Panelists: #{format_number(total_panelists)}\""
puts "\"Avg Panelist Lifespan: #{format_number(average_panelist_lifespan.round(2))} yrs\""
puts
puts 'Panelists Breakdown, Total Panelists, Avg. Lifespan'
puts "Active Panelists:,\"#{format_number(active_panelists.count)}\",\"#{format_number(active_years / active_panelists.count).to_f.round(2)}\""
puts "Deactivated Panelists:,\"#{format_number(deactivated_panelists.count)}\",\"#{format_number(deactivated_years / deactivated_panelists.count).to_f.round(2)}\""
puts "Suspended Panelists:,\"#{format_number(suspended_panelists.count)}\",\"#{format_number(suspended_years / suspended_panelists.count).to_f.round(2)}\""
puts "Deleted Panelists:,\"#{format_number(deleted_panelists.count)}\",\"#{format_number(deleted_years / deleted_panelists.count).to_f.round(2)}\""
puts
puts "Completed in: #{(Time.now.utc - start_time).to_i} seconds"
