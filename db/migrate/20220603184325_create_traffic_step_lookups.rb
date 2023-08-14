# frozen_string_literal: true

class CreateTrafficStepLookups < ActiveRecord::Migration[6.1]
  def change
    create_table :traffic_step_lookups do |t|
      t.text :uids, null: false

      t.timestamps
    end
  end
end
