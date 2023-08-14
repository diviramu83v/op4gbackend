# frozen_string_literal: true

# rails runner lib/scripts/reports/scores_of_panelists_suspended_in_bulk.rb > ~/Downloads/scores_of_panelists_suspended_in_bulk_report.csv

# Only panelists who were suspended in April-May 2021 have this specific note.
panelists = Panelist.suspended.joins(:notes).merge(PanelistNote.where(body: 'Manually suspended: failed CleanID'))

puts 'ID,Name,Email,Status,Suspended_at,Clean_id_score,Panelist_score,Panelist_score_percentile'

panelists.order(score: :desc).uniq.each do |panelist|
  row = [
    panelist.id,
    panelist.name,
    panelist.email,
    panelist.status,
    panelist.suspended_at,
    panelist.clean_id_data.dig('forensic', 'marker', 'score'),
    panelist.score,
    panelist.score_percentile
  ]

  puts row.join(',')
end
