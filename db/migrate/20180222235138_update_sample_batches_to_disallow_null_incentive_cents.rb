# frozen_string_literal: true

class UpdateSampleBatchesToDisallowNullIncentiveCents < ActiveRecord::Migration[5.1]
  def change
    SampleBatch.find_each { |batch| batch.update_attributes(incentive_cents: 300) }

    change_column_null(:sample_batches, :incentive_cents, false)
  end
end
