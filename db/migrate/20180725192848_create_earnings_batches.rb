# frozen_string_literal: true

class CreateEarningsBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :earnings_batches do |t|
      t.integer :amount_cents, null: false
      t.text :ids, null: false
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
