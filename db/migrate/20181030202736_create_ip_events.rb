# frozen_string_literal: true

class CreateIpEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :ip_events do |t|
      t.references :ip_address, foreign_key: true, null: false
      t.string :message, null: false

      t.timestamps
    end
  end
end
