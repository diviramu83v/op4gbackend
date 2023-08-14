# frozen_string_literal: true

# this adds methods for signup funnel reporting
# to be used by the Affiliate, RecruitingCampaign,
# Panel, and Nonprofit models
module RecruitingStats
  def started_signing_up_count
    panelists.count
  end

  def confirmed_email_address_count
    panelists.where.not(confirmed_at: nil).count
  end

  def completed_demos_count
    panelists.where.not(welcomed_at: nil).count
  end

  def still_active_count
    panelists.active.count
  end
end
