# frozen_string_literal: true

class AddSizeToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :count, :integer, null: false
  end
end
