# frozen_string_literal: true

class AddIndexToCleanIdDevicesOnDeviceCode < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :clean_id_devices, :device_code, algorithm: :concurrently, unique: true
  end
end
