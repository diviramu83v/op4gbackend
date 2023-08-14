# frozen_string_literal: true

class ConnectVendorBatchToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_reference :vendor_batches, :campaign, foreign_key: true, null: false
    remove_column :vendor_batches, :project_id, :integer
  end
end
