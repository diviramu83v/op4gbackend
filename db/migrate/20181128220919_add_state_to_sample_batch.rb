# frozen_string_literal: true

class AddStateToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :state, :string
  end
end
