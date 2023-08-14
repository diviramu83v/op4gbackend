# frozen_string_literal: true

class RemoveExternalFileColumnsFromVendorBatches < ActiveRecord::Migration[5.1]
  def change
    remove_column :vendor_batches, :notify_with_external_file, :boolean, default: false, null: false
    remove_column :vendor_batches, :external_notification_file_type, :string
    remove_column :vendor_batches, :external_notification_file_url, :string
  end
end
