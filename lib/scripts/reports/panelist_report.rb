# frozen_string_literal: true

# usage: rails runner lib/scripts/panelist_report.rb > ~/Downloads/panelist_report.csv

onboardings = Onboarding.complete.where('onboardings.created_at >= ?', 90.days.ago)
panelists = []

def calculate_percentage(part, whole)
  ((part / whole.to_f) * 100).round
end

onboardings.each do |onboarding|
  next unless onboarding.panelist

  next if panelists.include?(onboarding.panelist)

  panelists << onboarding.panelist
end

# rubocop:disable Metrics/BlockLength
CSV.open("#{Dir.home}/Downloads/panelist_report.csv", 'w') do |csv|
  csv << ['Email',
          'Total Completes',
          'Fraudulent Completes',
          'Fraudulent %',
          'Rejected Completes',
          'Rejected %',
          'Accepted Completes',
          'Accepted %',
          'Pending Completes',
          'Pending %',
          'Donation Percentage',
          'Panelist Page']
  panelists.each do |panelist|
    email = panelist.email || 'N/A'
    total_completes = onboardings.where(panelist: panelist)
    total = total_completes.count
    fraudulent = total_completes.where(client_status: :fraudulent).count
    rejected = total_completes.where(client_status: :rejected).count
    accepted = total_completes.where(client_status: :accepted).count
    pending = total_completes.where(client_status: nil).count
    csv << [email,
            total_completes.count,
            fraudulent,
            "#{calculate_percentage(fraudulent, total)}%",
            rejected,
            "#{calculate_percentage(rejected, total)}%",
            accepted,
            "#{calculate_percentage(accepted, total)}%",
            pending,
            "#{calculate_percentage(pending, total)}%",
            "#{panelist.donation_percentage}%",
            "https://admin.op4g.com/panelists/#{panelist.id}"]
  end
end
# rubocop:enable Metrics/BlockLength
