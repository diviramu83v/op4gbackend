# frozen_string_literal: true

puts 'week,project,source,blocked %'

Onramp.where('created_at > ?', 52.weeks.ago).order(:created_at).find_each do |onramp|
  next if onramp.draft?
  next if onramp.testing?
  next if onramp.started_count.zero?

  # next if onramp.started_count < 100

  output = ''

  output += "\"#{onramp.created_at.beginning_of_week.to_date}\","
  output += "\"#{onramp.project.id}\","
  output += "\"#{onramp.source_model_name}\","
  output += "\"#{onramp.blocked_count.to_f / onramp.started_count}\""

  puts output
end
