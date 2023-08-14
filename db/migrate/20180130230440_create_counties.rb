# frozen_string_literal: true

class CreateCounties < ActiveRecord::Migration[5.1]
  def change
    create_table :counties do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    add_index :counties, :code, unique: true
    add_index :counties, :name, unique: true
  end
end
