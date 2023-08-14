# frozen_string_literal: true

class CreateDemoQueryMsas < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_msas do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :msa, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_msas, [:demo_query_id, :msa_id], unique: true
  end
end
