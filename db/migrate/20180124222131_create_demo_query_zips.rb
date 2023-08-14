# frozen_string_literal: true

class CreateDemoQueryZips < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_zips do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :zip, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_zips, [:demo_query_id, :zip_id], unique: true
  end
end
