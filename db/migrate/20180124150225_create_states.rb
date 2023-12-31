# frozen_string_literal: true

class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    add_index :states, :code, unique: true
    add_index :states, :name, unique: true
  end
end
