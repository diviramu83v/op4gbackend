# frozen_string_literal: true

class AddPaymentUploadBatchToPayment < ActiveRecord::Migration[5.1]
  def change
    add_reference :payments, :payment_upload_batch, foreign_key: true
  end
end
