# frozen_string_literal: true

# 1 argument: client_id
# Usage: rails runner lib/scripts/export_acceptance_data_for_one_client.rb 742
# Usage: rails runner lib/scripts/export_acceptance_data_for_one_client.rb 742 > ~/Downloads/comscore_panel_completes.csv

client_id = ARGV[0]

puts 'Project ID,Survey name,Completes count,Accepted completes,Rejected completes,Payout'

client = Client.find(client_id)
projects = client.projects.order(:id)

projects.find_each do |project|
  project_id = project.id

  project.surveys.order(:id).find_each do |survey|
    survey_name = survey.name
    completes_count = survey.onboardings.complete.where.not(panelist_id: nil).count || 0
    earnings_count = survey.earnings.count || 0
    rejected_count = completes_count - earnings_count
    payout = survey.earnings.first&.total_amount || 0

    puts "\"#{project_id}\",\"#{survey_name}\",\"#{completes_count}\",\"#{earnings_count}\",\"#{rejected_count}\",\"#{payout}\""
  end
end
