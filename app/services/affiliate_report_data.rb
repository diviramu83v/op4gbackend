# frozen_string_literal: true

# Compile most of the data necessary for the affiliate report.
# rubocop:disable Metrics/ClassLength
class AffiliateReportData
  def initialize(start_period:, end_period:)
    @start_time = Date.parse(start_period)
    @end_time = Time.zone.parse(end_period).end_of_month
    @records = Panelist.find_by_sql [affiliate_report_query, { start_time: @start_time, end_time: @end_time }]
  end

  def affiliate_report_query
    <<~SQL
      SELECT
        affiliate_offer_list.affiliate_code,
        affiliate_offer_list.offer_code,
        conversion_data.tune_signup_count,
        affiliate_offer_list.db_signup_count,
        opportunity_data.opportunity_count,
        completion_data.completes_count,
        completion_data.completers_count,
        completion_data.accepted_completes,
        conversion_data.affiliate_payout,
        (coalesce(cpi_data.cpi_cents, 0) - coalesce(earnings_data.earnings_cents, 0) - coalesce(payout_data.payout_cents, 0)) / 100.0 AS roi_dollars
      FROM (
        SELECT
          affiliate_code,
          offer_code,
          SUM(
            CASE WHEN welcomed_at BETWEEN :start_time AND :end_time THEN
              1
            ELSE
              0
            END) AS db_signup_count
        FROM
          panelists
        WHERE
          affiliate_code IS NOT NULL
          AND offer_code IS NOT NULL
          AND affiliate_code != '{affiliate_id}'
        GROUP BY
          affiliate_code,
          offer_code
      ) AS affiliate_offer_list
        ----
        LEFT JOIN (
          SELECT
            affiliates.code AS affiliate_code,
            offers.code AS offer_code,
            count(*) AS tune_signup_count,
            sum(payout_cents) / 100.0 AS affiliate_payout
          FROM
            conversions
            JOIN affiliates ON conversions.affiliate_id = affiliates.id
            JOIN offers ON conversions.offer_id = offers.id
          WHERE
            tune_created_at BETWEEN :start_time AND :end_time
          GROUP BY
            affiliate_code,
            offer_code
      ) AS conversion_data ON affiliate_offer_list.affiliate_code = conversion_data.affiliate_code AND affiliate_offer_list.offer_code = conversion_data.offer_code
        ----
        LEFT JOIN (
          SELECT
            panelists.affiliate_code,
            panelists.offer_code,
            count(*) AS opportunity_count
          FROM
            project_invitations
            JOIN panelists ON project_invitations.panelist_id = panelists.id
          WHERE
            project_invitations.sent_at BETWEEN :start_time AND :end_time
          GROUP BY
            panelists.affiliate_code,
            panelists.offer_code
      ) AS opportunity_data ON affiliate_offer_list.affiliate_code = opportunity_data.affiliate_code AND affiliate_offer_list.offer_code = opportunity_data.offer_code
        ----
        LEFT JOIN (
          SELECT
            panelists.affiliate_code,
            panelists.offer_code,
            count(*) AS completes_count,
            count(DISTINCT panelist_id) AS completers_count,
            sum(CASE WHEN onboardings.client_status = 'accepted' THEN 1 ELSE 0 END) AS accepted_completes
          FROM
            onboardings
            JOIN panelists ON onboardings.panelist_id = panelists.id
            JOIN survey_response_urls ON onboardings.survey_response_url_id = survey_response_urls.id
          WHERE
            onboardings.status = 'survey_finished'
            AND survey_response_urls.slug = 'complete'
            AND onboardings.survey_finished_at BETWEEN :start_time AND :end_time
          GROUP BY
            panelists.affiliate_code,
            panelists.offer_code
      ) AS completion_data ON affiliate_offer_list.affiliate_code = completion_data.affiliate_code AND affiliate_offer_list.offer_code = completion_data.offer_code
      ----
      LEFT JOIN (
        SELECT
          affiliates.code,
          sum(surveys.cpi_cents) AS cpi_cents,
          panelists.offer_code AS offer_code
        FROM
          affiliates
          INNER JOIN panelists ON affiliates.code = panelists.affiliate_code
          INNER JOIN onboardings ON panelists.id = onboardings.panelist_id
          INNER JOIN onramps ON onboardings.onramp_id = onramps.id
          INNER JOIN surveys ON onramps.survey_id = surveys.id
        WHERE
          onboardings.status = 'survey_finished'
          AND survey_response_pattern_id = 1
          AND onboardings.survey_finished_at BETWEEN :start_time
          AND :end_time
        GROUP BY
          affiliates.code, offer_code) AS cpi_data ON affiliate_offer_list.affiliate_code = cpi_data.code AND affiliate_offer_list.offer_code = cpi_data.offer_code
      LEFT JOIN (
        SELECT
          panelists.affiliate_code,
          panelists.offer_code,
          sum(earnings.total_amount_cents) AS earnings_cents
        FROM
          earnings
          INNER JOIN panelists ON earnings.panelist_id = panelists.id
        WHERE
          panelists.affiliate_code IS NOT NULL
          AND earnings.created_at BETWEEN :start_time
          AND :end_time
        GROUP BY
          panelists.affiliate_code, panelists.offer_code) AS earnings_data ON affiliate_offer_list.affiliate_code = earnings_data.affiliate_code AND affiliate_offer_list.offer_code = earnings_data.offer_code
      LEFT JOIN (
        SELECT
          affiliates.code,
          sum(payout_cents) AS payout_cents
        FROM
          affiliates
          INNER JOIN conversions ON affiliates.id = conversions.affiliate_id
        WHERE
          conversions.tune_created_at BETWEEN :start_time
          AND :end_time
        GROUP BY
          affiliates.code) AS payout_data ON affiliate_offer_list.affiliate_code = payout_data.code
      WHERE
        affiliate_offer_list.db_signup_count > 0
        OR opportunity_data.opportunity_count > 0
        OR completion_data.completes_count > 0
      ORDER BY
        affiliate_offer_list.affiliate_code,
        affiliate_offer_list.offer_code
    SQL
  end

  attr_reader :records
end
# rubocop:enable Metrics/ClassLength
