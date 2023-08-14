# frozen_string_literal: true

class AddIncentiveToVendorBatch < ActiveRecord::Migration[5.1]
  def up
    add_column :vendor_batches, :incentive_cents, :integer

    VendorBatch.find_each do |batch|
      batch.update_attributes!(incentive_cents: 100) if batch.incentive_cents.nil?
    end

    change_column_null :vendor_batches, :incentive_cents, false
  end

  def down
    remove_column :vendor_batches, :incentive_cents
  end
end
