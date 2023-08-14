# frozen_string_literal: true

module RecruitmentSourceReport
  include ActiveSupport::Concern

  def total_donations(starting_at:, ending_at:)
    if is_a?(Nonprofit)
      donations.where('created_at BETWEEN ? and ?', starting_at,
                      ending_at).sum(:nonprofit_amount_cents) / 100
    else
      'n/a'
    end
  end

  def total_panelists(starting_at:, ending_at:)
    panelists.where('created_at BETWEEN ? AND ?', starting_at, ending_at).count
  end

  def total_signup(starting_at:, ending_at:)
    panelists.where(welcomed_at: nil).where('created_at BETWEEN ? and ?', starting_at, ending_at).count
  end

  # rubocop:disable Metrics/MethodLength
  def total_active(starting_at:, ending_at:)
    id_or_code = is_a?(Affiliate) ? code : id

    nonprofit_id_campaign_id_or_affiliate_code = 'affiliate_code'
    nonprofit_id_campaign_id_or_affiliate_code = 'nonprofit_id' if is_a?(Nonprofit)
    nonprofit_id_campaign_id_or_affiliate_code = 'campaign_id' if is_a?(RecruitingCampaign)

    ids = PanelistStatusEvent.find_by_sql [
      "SELECT MAX(panelist_status_events.id)
       FROM panelist_status_events
       WHERE panelist_status_events.created_at >= ? AND panelist_status_events.created_at <= ?
       GROUP BY panelist_id
       INTERSECT
       SELECT panelist_status_events.id FROM panelist_status_events
       JOIN panelists ON(panelist_id=panelists.id)
       WHERE panelist_status_events.status='active'
       AND panelists.created_at >= ? AND panelists.created_at <= ? AND panelists.
       #{nonprofit_id_campaign_id_or_affiliate_code} = ? ",
      starting_at, ending_at, starting_at, ending_at, id_or_code
    ]
    ids.count
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def total_deactivated(starting_at:, ending_at:)
    id_or_code = is_a?(Affiliate) ? code : id

    nonprofit_id_campaign_id_or_affiliate_code = 'affiliate_code'
    nonprofit_id_campaign_id_or_affiliate_code = 'nonprofit_id' if is_a?(Nonprofit)
    nonprofit_id_campaign_id_or_affiliate_code = 'campaign_id' if is_a?(RecruitingCampaign)

    ids = PanelistStatusEvent.find_by_sql [
      "SELECT MAX(panelist_status_events.id)
       FROM panelist_status_events
       WHERE panelist_status_events.created_at >= ? AND panelist_status_events.created_at <= ?
       GROUP BY panelist_id
       INTERSECT
       SELECT panelist_status_events.id FROM panelist_status_events
       JOIN panelists ON(panelist_id=panelists.id)
       WHERE panelist_status_events.status='deactivated'
       AND panelists.created_at >= ? AND panelists.created_at <= ? AND panelists.
       #{nonprofit_id_campaign_id_or_affiliate_code} = ? ",
      starting_at, ending_at, starting_at, ending_at, id_or_code
    ]
    ids.count
  end
  # rubocop:enable Metrics/MethodLength
end
