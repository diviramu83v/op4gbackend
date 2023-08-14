# frozen_string_literal: true

class RemoveNullConstraintFromRecruitingCampaignCampaignable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :recruiting_campaigns, :campaignable_type, true
    change_column_null :recruiting_campaigns, :campaignable_id, true
  end
end
