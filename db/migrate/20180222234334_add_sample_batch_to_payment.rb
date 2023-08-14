# frozen_string_literal: true

class AddSampleBatchToPayment < ActiveRecord::Migration[5.1]
  def change
    add_reference :payments, :sample_batch, foreign_key: true

    Payment.destroy_all

    change_column_null(:payments, :sample_batch_id, false)
  end
end
