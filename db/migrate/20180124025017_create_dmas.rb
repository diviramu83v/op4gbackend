# frozen_string_literal: true

class CreateDmas < ActiveRecord::Migration[5.1]
  def change
    create_table :dmas do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    add_index :dmas, :code, unique: true
    add_index :dmas, :name, unique: true
  end
end
