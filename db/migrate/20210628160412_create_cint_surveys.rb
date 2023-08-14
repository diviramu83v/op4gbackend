# frozen_string_literal: true

class CreateCintSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :cint_surveys do |t|
      t.string :name
      t.references :survey, foreign_key: true, null: false
      t.integer :limit, null: false
      t.integer :incidence_rate, null: false
      t.integer :loi, null: false
      t.text :variable_ids, default: [], array: true
      t.integer :cint_country_id

      t.timestamps
    end
  end
end
