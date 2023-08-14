# frozen_string_literal: true

# EXAMPLE: rails runner lib/scripts/weekly_recruitment_numbers.rb > ~/Downloads/recruitment-stats-20200316-20200322.txt

FIRST_DAY = '2020-03-16'

def print_title(text:)
  puts '-' * text.length
  puts text
  puts '-' * text.length
  puts
end

def print_subtitle(text:)
  puts text
  puts '-' * text.length
end

def print_data(records:)
  records.each do |key, value|
    puts "#{key}: #{value}"
  end
  puts
end

week_starts_at = Time.find_zone('UTC').parse(FIRST_DAY)
week_ends_at = (week_starts_at + 6.days).end_of_day

print_title(text: "#{week_starts_at} - #{week_ends_at}")

print_subtitle(text: 'Non-DOI')
records = Panelist.signing_up
                  .where.not(affiliate_code: nil)
                  .where('created_at >= ? AND created_at <= ?', week_starts_at, week_ends_at)
                  .group('affiliate_code')
                  .order('affiliate_code')
                  .count
print_data(records: records)

print_subtitle(text: 'DOI')
records = Panelist.completed_signup
                  .where.not(affiliate_code: nil)
                  .where('created_at >= ? AND created_at <= ?', week_starts_at, week_ends_at)
                  .group('affiliate_code')
                  .order('affiliate_code')
                  .count
print_data(records: records)

month_starts_at = Time.find_zone('UTC').parse('2019-09-01')

while month_starts_at < Time.now.utc
  month_ends_at = month_starts_at.end_of_month

  print_title(text: "#{month_starts_at.strftime('%B %Y')} panelists")

  print_subtitle(text: 'Invitations')
  records = ProjectInvitation.sent
                             .joins(:panelist)
                             .where.not(panelists: { affiliate_code: nil })
                             .where('project_invitations.sent_at >= ? AND project_invitations.sent_at <= ?', week_starts_at, week_ends_at)
                             .where('panelists.created_at >= ? AND panelists.created_at <= ?', month_starts_at, month_ends_at)
                             .select('panelists.affiliate_code')
                             .group('panelists.affiliate_code')
                             .order('panelists.affiliate_code')
                             .count
  print_data(records: records)

  print_subtitle(text: 'Completes')
  records = Onboarding.complete
                      .joins(:panelist)
                      .where.not(panelists: { affiliate_code: nil })
                      .where('onboardings.survey_finished_at >= ? AND onboardings.survey_finished_at <= ?', week_starts_at, week_ends_at)
                      .where('panelists.created_at >= ? AND panelists.created_at <= ?', month_starts_at, month_ends_at)
                      .select('panelists.affiliate_code')
                      .group('panelists.affiliate_code')
                      .order('panelists.affiliate_code')
                      .count
  print_data(records: records)

  print_subtitle(text: 'Completers')
  records = Onboarding.complete
                      .joins(:panelist)
                      .where.not(panelists: { affiliate_code: nil })
                      .where('onboardings.survey_finished_at >= ? AND onboardings.survey_finished_at <= ?', week_starts_at, week_ends_at)
                      .where('panelists.created_at >= ? AND panelists.created_at <= ?', month_starts_at, month_ends_at)
                      .select('panelists.affiliate_code')
                      .group('panelists.affiliate_code')
                      .order('panelists.affiliate_code')
                      .count('DISTINCT panelists.id')
  print_data(records: records)

  month_starts_at = month_starts_at.next_month
end
