# frozen_string_literal: true

class AddIndexToMakeSureVendorsArentAddedToACampaignMoreThanOnce < ActiveRecord::Migration[5.1]
  def change
    add_index :vendor_batches, [:campaign_id, :vendor_id], unique: true
  end
end
