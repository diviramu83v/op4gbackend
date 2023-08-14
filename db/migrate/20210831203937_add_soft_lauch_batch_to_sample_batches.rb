# frozen_string_literal: true

class AddSoftLauchBatchToSampleBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :sample_batches, :soft_launch_batch, :boolean
  end
end
