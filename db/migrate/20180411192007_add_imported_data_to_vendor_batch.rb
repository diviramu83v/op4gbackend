# frozen_string_literal: true

class AddImportedDataToVendorBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_batches, :imported_data, :text
  end
end
