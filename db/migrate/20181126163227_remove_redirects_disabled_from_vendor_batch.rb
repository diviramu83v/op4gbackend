# frozen_string_literal: true

class RemoveRedirectsDisabledFromVendorBatch < ActiveRecord::Migration[5.1]
  def change
    remove_column :vendor_batches, :redirects_disabled, :boolean, default: false, null: false
  end
end
