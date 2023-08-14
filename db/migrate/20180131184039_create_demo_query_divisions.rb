# frozen_string_literal: true

class CreateDemoQueryDivisions < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_divisions do |t|
      t.references :demo_query, foreign_key: true
      t.references :division, foreign_key: true

      t.timestamps
    end

    add_index :demo_query_divisions, [:demo_query_id, :division_id], unique: true
  end
end
