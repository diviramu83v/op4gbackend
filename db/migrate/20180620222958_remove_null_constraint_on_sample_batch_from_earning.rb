# frozen_string_literal: true

class RemoveNullConstraintOnSampleBatchFromEarning < ActiveRecord::Migration[5.1]
  def change
    change_column_null :earnings, :sample_batch_id, true
  end
end
