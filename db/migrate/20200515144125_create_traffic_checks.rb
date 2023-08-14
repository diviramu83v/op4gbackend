# frozen_string_literal: true

class CreateTrafficChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :traffic_checks do |t|
      t.references :traffic_step, foreign_key: true, null: false
      t.string :controller_action, null: false
      t.string :data_collected
      t.string :status, null: false
      t.string :ip_address, null: false

      t.timestamps
    end
  end
end
