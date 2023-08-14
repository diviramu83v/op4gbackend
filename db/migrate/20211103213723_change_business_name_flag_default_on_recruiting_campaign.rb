# frozen_string_literal: true

class ChangeBusinessNameFlagDefaultOnRecruitingCampaign < ActiveRecord::Migration[5.2]
  def change
    change_column_default :recruiting_campaigns, :business_name_flag, from: nil, to: false
  end
end
