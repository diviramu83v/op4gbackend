# frozen_string_literal: true

class CreateConversionTable < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :conversions do |t|
      t.references :offers, foreign_key: true, null: false
      t.string :tune_code, null: false
      t.integer :payout_cents, null: false

      t.timestamps
    end
    add_index :conversions, :tune_code, unique: true
  end
end
