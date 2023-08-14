# frozen_string_literal: true

class RemoveImportedDataFromVendorBatches < ActiveRecord::Migration[5.2]
  def change
    remove_column :vendor_batches, :imported_data, :text
  end
end
