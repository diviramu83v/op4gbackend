# frozen_string_literal: true

class CreateMsas < ActiveRecord::Migration[5.1]
  def change
    create_table :msas do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    add_index :msas, :code, unique: true
    add_index :msas, :name, unique: true
  end
end
