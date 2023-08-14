# frozen_string_literal: true

# rails runner lib/scripts/reports/panelists_scores.rb > ~/Downloads/panelists_scores_report.csv
include ActionView::Helpers::DateHelper
include ApplicationHelper

panelists = Panelist.scored.order(status: :asc)

puts 'ID,Name,email,status,panelist_since,length_of_tenure,recruitment_source,invitations_received,clicked,%_clicked,not_clicked,avg_reaction_time(min),recent_payouts,recent_net_profit,lifetime_payouts,lifetime_net_profit,accepted_completes,rejected_completes,fraudulent_completes,score,score_percentile,last_10_CleanID_scores,signup_CleanID_score'

# rubocop:disable Metrics/BlockLength
panelists.each do |panelist|
  PanelistScoreCalculator.new(panelist: panelist).calculate!

  name = "\"#{panelist.name.titleize}\""
  email = "\"#{panelist.email.downcase}\""
  panelist_since = panelist.created_at
  length_of_tenure = distance_of_time_in_words_to_now(panelist.created_at)
  recruitment_source = panelist.recruiting_source_name.present? ? "\"#{panelist.recruiting_source_name}\"" : 'N/A'

  invitations_received = panelist.recent_invitations.count
  total_invitations_clicked = panelist.recent_invitations_clicked
  percentage_of_invitations_clicked = format_percentage(panelist.percentage_of_recent_invitations_clicked)
  total_invitations_not_clicked = panelist.recent_invitations_not_clicked
  avg_reaction_time = panelist.average_reaction_time == 'N/A' ? 'N/A' : panelist.average_reaction_time

  recent_payouts = panelist.payments.where('paid_at >= ?', 18.months.ago).count
  recent_net_profit = panelist.recent_net_profit
  lifetime_payouts = panelist.payments.count
  lifetime_net_profit = panelist.net_profit

  accepted_completes = panelist.recent_accepted_count
  rejected_completes = panelist.recent_rejected_count
  fraudulent_completes = panelist.recent_fraudulent_count

  score = panelist.score || 'N/A'
  score_percentile = format_percentage_with_no_zeroes(panelist.score_percentile) || 'N/A'

  onboardings = panelist.onboardings.last(10)
  clean_id_scores = []

  onboardings.each do |onboarding|
    next if onboardings.blank?

    clean_id_data_locator = OnboardingCleanIdData.new(onboarding: onboarding)
    clean_id_data = clean_id_data_locator.pre_survey_clean_id_data

    next if clean_id_data.is_a?(String) || clean_id_data.blank?

    clean_id_score = clean_id_data.dig('forensic', 'marker', 'score') || 'n/a'
    clean_id_scores << clean_id_score
  end

  clean_id_scores = clean_id_scores.count > 1 ? clean_id_scores.join(',') : clean_id_scores.join
  clean_id_scores = clean_id_scores.blank? ? 'N/A' : "\"#{clean_id_scores}\""

  signup_clean_id_score = panelist.signup_clean_id_score

  row = [
    panelist.id,
    name,
    email,
    panelist.status,
    panelist_since,
    length_of_tenure,
    recruitment_source,
    invitations_received,
    total_invitations_clicked,
    percentage_of_invitations_clicked,
    total_invitations_not_clicked,
    avg_reaction_time,
    recent_payouts,
    recent_net_profit,
    lifetime_payouts,
    lifetime_net_profit,
    accepted_completes,
    rejected_completes,
    fraudulent_completes,
    score,
    score_percentile,
    clean_id_scores,
    signup_clean_id_score
  ]

  puts row.join(',')
end
# rubocop:enable Metrics/BlockLength
