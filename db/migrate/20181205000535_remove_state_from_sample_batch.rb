# frozen_string_literal: true

class RemoveStateFromSampleBatch < ActiveRecord::Migration[5.1]
  def change
    remove_column :sample_batches, :state, :string
  end
end
