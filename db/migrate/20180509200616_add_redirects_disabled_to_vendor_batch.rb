# frozen_string_literal: true

class AddRedirectsDisabledToVendorBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_batches, :redirects_disabled, :boolean, null: false, default: false
  end
end
