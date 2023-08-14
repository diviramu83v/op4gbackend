# frozen_string_literal: true

class CreatePanels < ActiveRecord::Migration[5.1]
  def change
    create_table :panels do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
