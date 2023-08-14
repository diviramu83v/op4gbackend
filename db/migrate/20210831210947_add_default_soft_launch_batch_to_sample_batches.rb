# frozen_string_literal: true

class AddDefaultSoftLaunchBatchToSampleBatches < ActiveRecord::Migration[5.2]
  def change
    change_column_default :sample_batches, :soft_launch_batch, from: nil, to: false
  end
end
