# frozen_string_literal: true

class ConnectSampleBatchToQuery < ActiveRecord::Migration[5.1]
  def change
    add_reference :sample_batches, :demo_query, foreign_key: true, null: false
    remove_column :sample_batches, :project_id, :integer
  end
end
