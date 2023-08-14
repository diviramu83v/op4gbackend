# frozen_string_literal: true

class AddExternalFileFieldsToVendorBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_batches, :notify_with_external_file, :boolean, null: false, default: false
    add_column :vendor_batches, :external_notification_file_type, :string
    add_column :vendor_batches, :external_notification_file_url, :string
  end
end
