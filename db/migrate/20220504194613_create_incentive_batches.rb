# frozen_string_literal: true

class CreateIncentiveBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :incentive_batches do |t|
      t.text :csv_data, array: true, default: []
      t.integer :reward_cents
      t.references :employee, foreign_key: true, null: false

      t.timestamps
    end
  end
end
