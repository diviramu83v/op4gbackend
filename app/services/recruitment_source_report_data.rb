# frozen_string_literal: true

# Compile most of the data necessary for the recruitment source report.
# rubocop:disable Metrics/ClassLength
class RecruitmentSourceReportData
  def initialize(starting_at:, ending_at:)
    @starting_at = starting_at
    @ending_at = ending_at
  end

  def affiliates
    @affiliates ||= Affiliate.find_by_sql [affiliate_query, query_params]
  end

  def nonprofits
    @nonprofits ||= Nonprofit.find_by_sql [nonprofit_query, query_params]
  end

  def others
    @others ||= RecruitingCampaign.find_by_sql [others_query, query_params]
  end

  private

  def query_params
    { starting_at: @starting_at, ending_at: @ending_at }
  end

  def others_query
    <<~SQL.squish
      SELECT
        all_others.id,
        all_others.code,
        coalesce(other_completes.completes, 0) AS completes,
        coalesce(other_completes.completers, 0) AS completers,
        coalesce(other_completes.accepted_completes, 0) AS accepted_completes,
        coalesce(other_completes.cpi_cents, 0) AS cpi_cents,
        coalesce(other_earnings.earnings_cents, 0) AS earnings_cents,
        (coalesce(other_completes.cpi_cents, 0) - coalesce(other_earnings.earnings_cents, 0)) / 100.0 AS roi_dollars
      FROM (
        SELECT
          id,
          code
        FROM
          recruiting_campaigns
        WHERE
          campaignable_type IS NULL
      ) AS all_others
      LEFT JOIN (
        SELECT
          recruiting_campaigns.id,
          count(DISTINCT panelists.id) AS panelist_count,
          count(DISTINCT onboardings.id) AS completes,
          count(DISTINCT onboardings.panelist_id) AS completers,
          sum(CASE WHEN onboardings.client_status = 'accepted' THEN 1 ELSE 0 END) AS accepted_completes,
          sum(surveys.cpi_cents) AS cpi_cents
        FROM
          recruiting_campaigns
          JOIN panelists ON recruiting_campaigns.id = panelists.campaign_id
          JOIN onboardings ON panelists.id = onboardings.panelist_id
          JOIN onramps ON onboardings.onramp_id = onramps.id
          JOIN surveys ON onramps.survey_id = surveys.id
          JOIN survey_response_urls ON onboardings.survey_response_url_id = survey_response_urls.id
        WHERE
          recruiting_campaigns.campaignable_type IS NULL
          AND onboardings.status = 'survey_finished'
          AND survey_response_urls.slug = 'complete'
          AND onboardings.survey_finished_at BETWEEN :starting_at AND :ending_at
        GROUP BY
          recruiting_campaigns.id) AS other_completes ON all_others.id = other_completes.id
      LEFT JOIN (
        SELECT
          recruiting_campaigns.id,
          sum(earnings.total_amount_cents) AS earnings_cents
        FROM
          recruiting_campaigns
          JOIN panelists ON recruiting_campaigns.id = panelists.campaign_id
          JOIN earnings ON panelists.id = earnings.panelist_id
        WHERE
          recruiting_campaigns.campaignable_type IS NULL
          AND earnings.created_at BETWEEN :starting_at AND :ending_at
        GROUP BY
          recruiting_campaigns.id) AS other_earnings ON all_others.id = other_earnings.id;
    SQL
  end

  def affiliate_query
    <<~SQL.squish
      SELECT
        all_affiliates.code,
        all_affiliates.name,
        coalesce(affiliate_completes.completes, 0) AS completes,
        coalesce(affiliate_completes.completers, 0) AS completers,
        coalesce(affiliate_completes.accepted_completes, 0) AS accepted_completes,
        coalesce(affiliate_completes.cpi_cents, 0) AS cpi_cents,
        coalesce(affiliate_earnings.earnings_cents, 0) AS earnings_cents,
        coalesce(affiliate_payouts.payout_cents, 0) AS payout_cents,
        (coalesce(affiliate_completes.cpi_cents, 0) - coalesce(affiliate_earnings.earnings_cents, 0) - coalesce(affiliate_payouts.payout_cents, 0)) / 100.0 AS roi_dollars
      FROM (
        SELECT
          code,
          name
        FROM
          affiliates) AS all_affiliates
        LEFT JOIN (
          SELECT
            affiliates.code,
            count(*) AS completes,
            count(DISTINCT onboardings.panelist_id) AS completers,
            sum(CASE WHEN onboardings.client_status = 'accepted' THEN 1 ELSE 0 END) AS accepted_completes,
            sum(surveys.cpi_cents) AS cpi_cents
          FROM
            affiliates
            JOIN panelists ON affiliates.code = panelists.affiliate_code
            JOIN onboardings ON panelists.id = onboardings.panelist_id
            JOIN onramps ON onboardings.onramp_id = onramps.id
            JOIN surveys ON onramps.survey_id = surveys.id
            JOIN survey_response_urls ON onboardings.survey_response_url_id = survey_response_urls.id
          WHERE
            onboardings.status = 'survey_finished'
            AND survey_response_urls.slug = 'complete'
            AND onboardings.survey_finished_at BETWEEN :starting_at AND :ending_at
          GROUP BY
            affiliates.code) AS affiliate_completes ON all_affiliates.code = affiliate_completes.code
        LEFT JOIN (
          SELECT
            panelists.affiliate_code,
            sum(earnings.total_amount_cents) AS earnings_cents
          FROM
            earnings
            JOIN panelists ON earnings.panelist_id = panelists.id
          WHERE
            panelists.affiliate_code IS NOT NULL
            AND earnings.created_at BETWEEN :starting_at AND :ending_at
          GROUP BY
            panelists.affiliate_code) AS affiliate_earnings ON all_affiliates.code = affiliate_earnings.affiliate_code
        LEFT JOIN (
          SELECT
            affiliates.code,
            sum(payout_cents) AS payout_cents
          FROM
            affiliates
            JOIN conversions ON affiliates.id = conversions.affiliate_id
          WHERE
            conversions.tune_created_at BETWEEN :starting_at AND :ending_at
          GROUP BY
            affiliates.code) AS affiliate_payouts ON all_affiliates.code = affiliate_payouts.code
      ORDER BY
        cast(affiliate_completes.code AS int);
    SQL
  end

  def nonprofit_query
    <<~SQL.squish
      SELECT
        all_nonprofits.id,
        all_nonprofits.name,
        coalesce(nonprofit_completes.completes, 0) AS completes,
        coalesce(nonprofit_completes.completers, 0) AS completers,
        coalesce(nonprofit_completes.accepted_completes, 0) AS accepted_completes,
        coalesce(nonprofit_completes.cpi_cents, 0) AS cpi_cents,
        coalesce(nonprofit_earnings.earnings_cents, 0) AS earnings_cents,
        (coalesce(nonprofit_completes.cpi_cents, 0) - coalesce(nonprofit_earnings.earnings_cents, 0)) / 100.0 AS roi_dollars
      FROM (
        SELECT
          id,
          name
        FROM
          nonprofits) AS all_nonprofits
        LEFT JOIN (
          SELECT
            nonprofits.id,
            count(*) AS completes,
            count(DISTINCT onboardings.panelist_id) AS completers,
            sum(CASE WHEN onboardings.client_status = 'accepted' THEN 1 ELSE 0 END) AS accepted_completes,
            sum(surveys.cpi_cents) AS cpi_cents
          FROM
            nonprofits
            JOIN panelists ON nonprofits.id = panelists.nonprofit_id
            JOIN onboardings ON panelists.id = onboardings.panelist_id
            JOIN onramps ON onboardings.onramp_id = onramps.id
            JOIN surveys ON onramps.survey_id = surveys.id
            JOIN survey_response_urls ON onboardings.survey_response_url_id = survey_response_urls.id
          WHERE
            onboardings.status = 'survey_finished'
            AND survey_response_urls.slug = 'complete'
            AND onboardings.survey_finished_at BETWEEN :starting_at AND :ending_at
          GROUP BY
            nonprofits.id) AS nonprofit_completes ON all_nonprofits.id = nonprofit_completes.id
        LEFT JOIN (
          SELECT
            earnings.nonprofit_id,
            sum(earnings.total_amount_cents) AS earnings_cents
          FROM
            earnings
          WHERE
            earnings.nonprofit_id IS NOT NULL
            AND earnings.created_at BETWEEN :starting_at AND :ending_at
          GROUP BY
            earnings.nonprofit_id) AS nonprofit_earnings ON all_nonprofits.id = nonprofit_earnings.nonprofit_id
      WHERE
        nonprofit_completes.completes IS NOT NULL
        OR nonprofit_completes.completers IS NOT NULL
        OR nonprofit_completes.cpi_cents IS NOT NULL
        OR nonprofit_earnings.earnings_cents IS NOT NULL
        OR nonprofit_completes.cpi_cents IS NOT NULL
        OR nonprofit_earnings.earnings_cents IS NOT NULL
      ORDER BY
        nonprofit_completes.id;
    SQL
  end
end
# rubocop:enable Metrics/ClassLength
