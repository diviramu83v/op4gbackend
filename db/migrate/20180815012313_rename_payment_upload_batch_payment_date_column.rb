# frozen_string_literal: true

class RenamePaymentUploadBatchPaymentDateColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :payment_upload_batches, :payment_date, :paid_at
  end
end
