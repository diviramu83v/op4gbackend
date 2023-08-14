# frozen_string_literal: true

class AddRemindedAtToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :reminder_finished_at, :datetime
    add_column :sample_batches, :reminder_started_at, :datetime
  end
end
