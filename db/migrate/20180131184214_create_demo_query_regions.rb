# frozen_string_literal: true

class CreateDemoQueryRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_regions do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :region, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_regions, [:demo_query_id, :region_id], unique: true
  end
end
