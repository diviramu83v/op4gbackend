# frozen_string_literal: true

class CreateProductTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :product_types do |t|
      t.string :name, null: false
      t.integer :sort, null: false, default: 0

      t.timestamps
    end
  end
end
