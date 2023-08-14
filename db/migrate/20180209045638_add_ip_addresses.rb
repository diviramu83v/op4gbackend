# frozen_string_literal: true

class AddIpAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :ip_addresses do |t|
      t.string :address, null: false
      t.integer :request_count, null: false, default: 0
      t.integer :blocked_count, null: false, default: 0
      t.datetime :blocked_at, null: true

      t.timestamps
    end

    add_index :ip_addresses, :address, unique: true
  end
end
