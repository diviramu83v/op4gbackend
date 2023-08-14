# frozen_string_literal: true

class CreateCloseOutReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :close_out_reasons do |t|
      t.string :title, null: false
      t.text :definition
      t.string :category, null: false

      t.timestamps
    end
  end
end
