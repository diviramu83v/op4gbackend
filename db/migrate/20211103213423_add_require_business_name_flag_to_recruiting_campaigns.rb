# frozen_string_literal: true

class AddRequireBusinessNameFlagToRecruitingCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :recruiting_campaigns, :business_name_flag, :boolean
  end
end
