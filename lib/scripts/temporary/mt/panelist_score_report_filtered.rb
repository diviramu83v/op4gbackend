# frozen_string_literal: true

# rails runner lib/scripts/temporary/mt/panelist_score_report_filtered.rb > ~/Downloads/filtered_panelists_scores_report.csv
include ActionView::Helpers::DateHelper
include ApplicationHelper

# onboardings = Onboarding.complete.where('onboardings.created_at >= ?', 45.days.ago)
ids = %w[30186582
         30187374
         30187060
         30187286
         30183759
         30186565
         30186564
         30186571
         30186569
         30186550
         30186488
         30182300
         30182554
         30182370
         30183484
         30183029
         30182993
         30181255
         30186478
         30186475
         30180348
         30179940
         30163453
         30159492
         30158888
         30158736
         30168982
         30171228
         30188023
         30175493
         30168935
         30154183
         30116691
         30154223
         30180380
         30187805
         30154286
         30061521
         30186299
         30186414
         30186391
         30186420
         30186322
         30186346
         30186357
         30186375
         30186222
         30186404
         30186336
         30159030
         19900930
         30154633
         98906
         30163387
         30091079
         30161966
         30054350
         30154404
         30170688
         30171006
         30179342
         30174643
         30169080
         30185107
         30185125
         30185664
         30185151
         30185452
         30185043
         30185388
         30185436
         30167071
         30006501
         30137358
         30040863
         30167432
         30046959
         30005414
         30174258
         30154793
         30121038
         30005338
         30002562
         30036162
         30170918
         30136577
         30123277
         30168177
         30008461
         92067
         30107387
         19977223
         30125451
         30003035
         30107290
         30115800]

# panelists = onboardings.map(&:panelist).compact.uniq
panelists = ids.map { |id| Panelist.find(id) }

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

    clean_id_score = clean_id_data.dig('forensic', 'marker', 'score')
    clean_id_scores << clean_id_score if clean_id_score.present?
  end

  next unless clean_id_scores.select(&:positive?).any?

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
