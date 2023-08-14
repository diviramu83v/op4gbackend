# frozen_string_literal: true

puts 'week,project,started at,waiting at,finished at,# of days active'

Project.where('created_at > ?', 52.weeks.ago).order(:created_at).find_each do |project|
  next if project.draft?

  output = ''

  stopped_at = project.waiting_at || project.finished_at
  next if stopped_at.nil?

  output += "\"#{project.created_at.beginning_of_week.to_date}\","
  output += "\"#{project.id}\","
  output += "\"#{project.started_at}\","
  output += "\"#{project.waiting_at}\","
  output += "\"#{project.finished_at}\","
  output += "\"#{(stopped_at.to_date - project.started_at.to_date).to_i}\""

  puts output
end
