# frozen_string_literal: true

class AddCampaignableToRecruitingCampaign < ActiveRecord::Migration[5.1]
  def change
    add_reference :recruiting_campaigns, :campaignable, polymorphic: true, index: { name: 'index_campaigns_on_campaignable_type_and_campaignable_id' }

    change_column_null :recruiting_campaigns, :campaignable_id, false
    change_column_null :recruiting_campaigns, :campaignable_type, false
  end
end
