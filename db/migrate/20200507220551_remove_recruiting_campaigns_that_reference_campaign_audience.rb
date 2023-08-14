# frozen_string_literal: true

class RemoveRecruitingCampaignsThatReferenceCampaignAudience < ActiveRecord::Migration[5.2]
  def change
    RecruitingCampaign.where(campaignable_type: 'CampaignAudience').destroy_all
  end
end
