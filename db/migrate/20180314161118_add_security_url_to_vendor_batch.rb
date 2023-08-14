# frozen_string_literal: true

class AddSecurityUrlToVendorBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_batches, :security_url, :string
  end
end
