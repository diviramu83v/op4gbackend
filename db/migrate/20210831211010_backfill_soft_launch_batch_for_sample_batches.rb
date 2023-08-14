# frozen_string_literal: true

class BackfillSoftLaunchBatchForSampleBatches < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    SampleBatch.find_each do |batch|
      next unless batch.soft_launch_batch.nil?

      batch.update_column(:soft_launch_batch, false)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
