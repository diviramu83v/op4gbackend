# frozen_string_literal: true

class AddLockFlagToRecruitingCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :recruiting_campaigns, :lock_flag, :boolean
  end
end
