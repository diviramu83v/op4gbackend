# frozen_string_literal: true

class CreatePaymentUploadBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_upload_batches do |t|
      t.datetime :payment_date, null: false
      t.string :period, null: false
      t.text :payment_data, null: false

      t.timestamps
    end
  end
end
