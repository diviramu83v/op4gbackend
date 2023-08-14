# frozen_string_literal: true

# rails runner lib/scripts/reports/invitations_by_panel.rb

puts 'name,active panelist count,invitation count,complete count'

Panel.active.each do |panel|
  name = panel.name
  active_panelists = panel.panelists.active.count
  sent_invitations = panel.invitations.has_been_sent.where('project_invitations.created_at >= ?', 30.days.ago).count
  completes = panel.onboardings.complete.where('survey_finished_at >= ?', 30.days.ago).count

  puts "#{name},#{active_panelists},#{sent_invitations},#{completes}"
end
