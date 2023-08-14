# frozen_string_literal: true

class CreateDivisions < ActiveRecord::Migration[5.1]
  def change
    create_table :divisions do |t|
      t.string :name

      t.timestamps
    end

    add_index :divisions, :name, unique: true
  end
end
