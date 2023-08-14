# frozen_string_literal: true

class DropCampaignAudience < ActiveRecord::Migration[5.2]
  def change
    drop_table :campaign_audiences
  end
end
