# frozen_string_literal: true

# this adds methods for the panelist
# lifecycle reporting stats for the
# Affiliate, RecruitingCampaign,
# Panel, and Nonprofit models
module LifecycleStats
  def active_panelists_count
    panelists.active.count
  end

  def suspended_panelists_count
    panelists.suspended.count
  end

  def deactivated_panelists_count
    panelists.deactivated.count
  end

  def deleted_panelists_count
    panelists.deleted.count
  end
end
