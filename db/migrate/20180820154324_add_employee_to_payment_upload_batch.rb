# frozen_string_literal: true

class AddEmployeeToPaymentUploadBatch < ActiveRecord::Migration[5.1]
  def change
    add_reference :payment_upload_batches, :employee, null: false, foreign_key: true
  end
end
