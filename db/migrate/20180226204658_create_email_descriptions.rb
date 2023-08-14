# frozen_string_literal: true

class CreateEmailDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :email_descriptions do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :default, null: false, default: false
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
