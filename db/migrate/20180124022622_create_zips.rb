# frozen_string_literal: true

class CreateZips < ActiveRecord::Migration[5.1]
  def change
    create_table :zips do |t|
      t.string :code, null: false

      t.timestamps
    end

    add_index :zips, :code, unique: true
  end
end
