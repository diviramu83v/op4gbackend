# frozen_string_literal: true

class AddTriggeredAtToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :triggered_at, :timestamp
  end
end
