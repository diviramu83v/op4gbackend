# frozen_string_literal: true

class AddDefaultLockFlagToRecruitingCampaigns < ActiveRecord::Migration[5.2]
  def change
    change_column_default :recruiting_campaigns, :lock_flag, false
  end
end
