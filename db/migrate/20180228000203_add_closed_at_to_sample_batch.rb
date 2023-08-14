# frozen_string_literal: true

class AddClosedAtToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :closed_at, :datetime
  end
end
