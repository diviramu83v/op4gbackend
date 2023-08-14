# frozen_string_literal: true

class RemoveEmailFromCampaignAudience < ActiveRecord::Migration[5.1]
  def change
    remove_column :campaign_audiences, :email, :string
  end
end
