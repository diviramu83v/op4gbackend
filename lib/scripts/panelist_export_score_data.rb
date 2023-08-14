# frozen_string_literal: true

# This lists the top and bottom scoring panelists
# and prints their score, name, and email

# To get the most up to date scores first run:
# rails runner lib/scripts/calculate_active_panelists_score.rb

# Then run this script with:
# rails runner lib/scripts/panelist_export_score_data.rb > ~/Downloads/panelist-score-data.csv

sorted_panelists = Panelist.active.sort_by(&:score)

puts 'accepted count,rejected count,fraudulent count,email,link'

sorted_panelists.reverse.each do |panelist|
  row = [
    panelist.recent_accepted_count,
    panelist.recent_rejected_count,
    panelist.recent_fraudulent_count,
    panelist.email,
    "https://admin.op4g.com/panelists/#{panelist.id}"
  ]

  puts row.join(',')
end
