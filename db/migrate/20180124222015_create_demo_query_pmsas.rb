# frozen_string_literal: true

class CreateDemoQueryPmsas < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_pmsas do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :pmsa, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_pmsas, [:demo_query_id, :pmsa_id], unique: true
  end
end
