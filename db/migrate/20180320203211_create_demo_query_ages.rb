# frozen_string_literal: true

class CreateDemoQueryAges < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_ages do |t|
      t.references :demo_query, foreign_key: true
      t.references :age, foreign_key: true

      t.timestamps
    end

    add_index :demo_query_ages, [:demo_query_id, :age_id], unique: true
  end
end
