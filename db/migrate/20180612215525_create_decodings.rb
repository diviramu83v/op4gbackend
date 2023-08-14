# frozen_string_literal: true

class CreateDecodings < ActiveRecord::Migration[5.1]
  def change
    create_table :decodings do |t|
      t.text :encoded_uids, null: false
      t.references :employee, foreign_key: true, null: false

      t.timestamps
    end
  end
end
