# frozen_string_literal: true

class AddErrorDataToPaymentUploadBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_upload_batches, :error_data, :text
  end
end
