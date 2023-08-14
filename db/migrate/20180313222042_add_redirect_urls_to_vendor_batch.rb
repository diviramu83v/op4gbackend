# frozen_string_literal: true

class AddRedirectUrlsToVendorBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_batches, :complete_url, :string
    add_column :vendor_batches, :terminate_url, :string
    add_column :vendor_batches, :overquota_url, :string
  end
end
