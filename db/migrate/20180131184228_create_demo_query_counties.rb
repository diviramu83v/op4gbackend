# frozen_string_literal: true

class CreateDemoQueryCounties < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_counties do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :county, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_counties, [:demo_query_id, :county_id], unique: true
  end
end
