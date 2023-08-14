# frozen_string_literal: true

class AddSurveyIdToVendorBatches < ActiveRecord::Migration[5.2]
  def change
    add_reference :vendor_batches, :survey, foreign_key: true
  end
end
