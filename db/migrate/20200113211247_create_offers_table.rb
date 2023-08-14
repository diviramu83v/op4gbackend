# frozen_string_literal: true

class CreateOffersTable < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :offers do |t|
      t.string :offer_code, null: false
      t.string :offer_name

      t.timestamps
    end
    add_index :offers, :offer_code, unique: true
  end
end
