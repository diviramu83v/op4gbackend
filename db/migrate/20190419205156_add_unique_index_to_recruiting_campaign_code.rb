# frozen_string_literal: true

class AddUniqueIndexToRecruitingCampaignCode < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    add_index :recruiting_campaigns, :code, unique: true
  end
end
