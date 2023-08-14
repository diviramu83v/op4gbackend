# frozen_string_literal: true

class CreateEarnings < ActiveRecord::Migration[5.1]
  def change
    create_table :earnings do |t|
      t.references :sample_batch, foreign_key: true, null: false
      t.references :panelist, foreign_key: true, null: false
      t.integer :total_amount_cents, null: false, default: 0
      t.integer :panelist_amount_cents, null: false, default: 0
      t.integer :nonprofit_amount_cents, null: false, default: 0
      t.references :nonprofit, foreign_key: true, null: false
      t.boolean :npom, null: false, default: false
      t.string :period, null: false
      t.text :imported_data

      t.timestamps
    end
  end
end
