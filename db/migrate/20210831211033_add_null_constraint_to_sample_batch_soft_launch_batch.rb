# frozen_string_literal: true

class AddNullConstraintToSampleBatchSoftLaunchBatch < ActiveRecord::Migration[5.2]
  def change
    change_column_null :sample_batches, :soft_launch_batch, false
  end
end
