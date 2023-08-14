# frozen_string_literal: true

class CreatePanelists < ActiveRecord::Migration[5.1]
  def change
    create_table :panelists do |t|
      t.references :panel, null: false
      t.text :imported_data

      t.timestamps
    end

    add_foreign_key :panelists, :panels
  end
end
