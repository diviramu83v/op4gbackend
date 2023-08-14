# frozen_string_literal: true

class CreateVendorBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_batches do |t|
      t.references :project, foreign_key: true, null: false
      t.references :vendor, foreign_key: true, null: false

      t.timestamps
    end
  end
end
