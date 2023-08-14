# frozen_string_literal: true

class CreateCleanIdDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :clean_id_devices do |t|
      t.string :device_code, null: false

      t.timestamps
    end
  end
end
