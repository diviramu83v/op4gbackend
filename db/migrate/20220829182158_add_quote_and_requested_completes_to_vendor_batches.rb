# frozen_string_literal: true

class AddQuoteAndRequestedCompletesToVendorBatches < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_table :vendor_batches, bulk: true do |t|
        t.integer :quoted_completes
        t.integer :requested_completes
      end
    end
  end
end
