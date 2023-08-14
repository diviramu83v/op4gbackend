# frozen_string_literal: true

class AddTuneCreatedAtToConversion < ActiveRecord::Migration[5.1]
  def change
    add_column :conversions, :tune_created_at, :datetime
  end
end
