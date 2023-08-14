# frozen_string_literal: true

# no arguments
# Usage: rails runner lib/scripts/export_acceptance_data_for_all_clients.rb
# Usage: rails runner lib/scripts/export_acceptance_data_for_all_clients.rb > ~/Downloads/recent_projects_panel_completes.csv

puts 'Project ID,Client name,Survey name,Completes count,Accepted completes,Rejected completes,Payout'

projects = Project.finished.where('finished_at > ?', Time.now.utc - 6.months)

projects.find_each do |project|
  project_id = project.id
  client = project.client

  project.surveys.order(:id).find_each do |survey|
    client_name = client.name
    survey_name = survey.name
    completes_count = survey.onboardings.complete.where.not(panelist_id: nil).count || 0
    earnings_count = survey.earnings.count || 0
    rejected_count = completes_count - earnings_count
    payout = survey.earnings.first&.total_amount || 0

    puts "\"#{project_id}\",\"#{client_name}\",\"#{survey_name}\",\"#{completes_count}\",\"#{earnings_count}\",\"#{rejected_count}\",\"#{payout}\""
  end
end
