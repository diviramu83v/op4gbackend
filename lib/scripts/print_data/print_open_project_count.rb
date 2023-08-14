# frozen_string_literal: true

puts 'week,project,started at,waiting at,finished at,open'

Project.where('created_at > ?', 52.weeks.ago).order(:created_at).find_each do |project|
  next if project.draft?
  next if project.archived?

  output = ''

  stopped_at = project.waiting_at || project.finished_at
  next if stopped_at.present?

  output += "\"#{project.created_at.beginning_of_week.to_date}\","
  output += "\"#{project.id}\","
  output += "\"#{project.started_at}\","
  output += "\"#{project.waiting_at}\","
  output += "\"#{project.finished_at}\","
  output += '"1"'

  puts output
end
