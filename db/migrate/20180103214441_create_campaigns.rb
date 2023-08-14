# frozen_string_literal: true

class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :target
      t.integer :cpi

      t.timestamps
    end
  end
end
