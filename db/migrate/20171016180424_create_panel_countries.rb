# frozen_string_literal: true

class CreatePanelCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :panel_countries do |t|
      t.references :panel, foreign_key: true, null: false
      t.references :country, foreign_key: true, null: false

      t.timestamps
    end
  end
end
