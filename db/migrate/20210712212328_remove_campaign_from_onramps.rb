# frozen_string_literal: true

class RemoveCampaignFromOnramps < ActiveRecord::Migration[5.2]
  def change
    remove_column :onramps, :campaign_id, :bigint
  end
end
