# frozen_string_literal: true

# export data for panelists report
class ExportPanelistsReportDataJob < ApplicationJob
  include ActionView::Helpers::DateHelper
  include ApplicationHelper

  queue_as :ui

  def perform(current_user) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    @panelists = Panelist.scorable.order(status: :asc)
    file = CSV.generate do |csv| # rubocop:disable Metrics/BlockLength
      csv << ['Name', 'email', 'status', 'panelist_since', 'length_of_tenure',
              'recruitment_source', 'invitations_received', 'clicked', '%_clicked',
              'not_clicked', 'avg_reaction_time(min)', 'recent_payouts', 'recent_net_incentive_margin',
              'lifetime_payouts', 'lifetime_net_incentive_margin', 'accepted_completes', 'rejected_completes',
              'fraudulent_completes', 'score', 'score_percentile', 'last_10_CleanID_scores', 'signup_CleanID_score', 'OR_score']

      @panelists.each do |panelist| # rubocop:disable Metrics/BlockLength
        PanelistScoreCalculator.new(panelist: panelist).calculate! unless panelist.score.nil?

        name = panelist.name.titleize
        email = panelist.email.downcase
        panelist_since = panelist.created_at
        length_of_tenure = distance_of_time_in_words_to_now(panelist.created_at)
        recruitment_source = panelist.recruiting_source_name.presence || 'N/A'

        invitations_received = format_number(panelist.recent_invitations.count)
        total_invitations_clicked = panelist.recent_invitations_clicked.presence || 'N/A'
        percentage_of_invitations_clicked = format_percentage(panelist.percentage_of_recent_invitations_clicked)
        total_invitations_not_clicked = panelist.recent_invitations_not_clicked.presence || 'N/A'
        avg_reaction_time = format_number(panelist.average_reaction_time)

        recent_payouts = panelist.payments.where('paid_at >= ?', 18.months.ago).count
        recent_net_incentive_margin = format_currency_with_zeroes(panelist.recent_net_profit)
        lifetime_payouts = panelist.payments.count
        lifetime_net_incentive_margin = format_currency_with_zeroes(panelist.net_profit)

        accepted_completes = panelist.recent_accepted_count
        rejected_completes = panelist.recent_rejected_count
        fraudulent_completes = panelist.recent_fraudulent_count

        score = panelist.score || 'N/A'
        score_percentile = format_percentage_with_no_zeroes(panelist.score_percentile)

        signup_clean_id_score = panelist.signup_clean_id_score.presence || 'N/A'
        or_score = if panelist.clean_id_data.blank? || panelist.clean_id_data.is_a?(String) || panelist.clean_id_data.key?('error')
                     'N/A'
                   else
                     panelist.clean_id_data&.dig('ORScore') || 'N/A'
                   end

        onboardings = panelist.onboardings.last(10)

        clean_id_scores = onboardings.map do |onboarding|
          next if onboardings.blank?

          next if onboarding.clean_id_data.blank? || onboarding.clean_id_data.is_a?(String) || onboarding.clean_id_data.key?('error')

          if onboarding.clean_id_data.key?('forensic')
            onboarding.clean_id_data&.dig('forensic', 'marker', 'score') || 'n/a'
          elsif onboarding.clean_id_data.key?('TransactionId')
            onboarding.clean_id_data&.dig('Score') || 'n/a'
          else
            next
          end
        end

        clean_id_scores = clean_id_scores.compact_blank
        clean_id_scores = clean_id_scores.count > 1 ? clean_id_scores.join(',') : clean_id_scores.join

        csv << [
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
          recent_net_incentive_margin,
          lifetime_payouts,
          lifetime_net_incentive_margin,
          accepted_completes,
          rejected_completes,
          fraudulent_completes,
          score,
          score_percentile,
          clean_id_scores.presence || 'N/A',
          signup_clean_id_score,
          or_score
        ]
      end
    end

    ActionCable.server.broadcast(
      "panelists_report_download_channel_#{current_user.id}",
      { csv_file: {
        file_name: 'panelists_report.csv',
        content: file
      } }
    )
  end
end
