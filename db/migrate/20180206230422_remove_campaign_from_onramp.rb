# frozen_string_literal: true

class RemoveCampaignFromOnramp < ActiveRecord::Migration[5.1]
  def change
    remove_column :onramps, :campaign_id, :integer
  end
end
