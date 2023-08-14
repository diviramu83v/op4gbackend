# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
