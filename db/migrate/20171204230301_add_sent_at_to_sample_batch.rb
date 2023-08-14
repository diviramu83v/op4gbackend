# frozen_string_literal: true

class AddSentAtToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :sent_at, :datetime
  end
end
