# frozen_string_literal: true

class CreateDemoQueryStateCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_state_codes do |t|
      t.references :demo_query, foreign_key: true
      t.string :code

      t.timestamps
    end

    add_index :demo_query_state_codes, [:demo_query_id, :code], unique: true
  end
end
