# frozen_string_literal: true

class CreateAges < ActiveRecord::Migration[5.1]
  def change
    create_table :ages do |t|
      t.integer :value, null: false

      t.timestamps
    end

    add_index :ages, :value, unique: true
  end
end
