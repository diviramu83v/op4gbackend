# frozen_string_literal: true

class CreatePmsas < ActiveRecord::Migration[5.1]
  def change
    create_table :pmsas do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    add_index :pmsas, :code, unique: true
    add_index :pmsas, :name, unique: true
  end
end
