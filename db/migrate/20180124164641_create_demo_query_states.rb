# frozen_string_literal: true

class CreateDemoQueryStates < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_states do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :state, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_states, [:demo_query_id, :state_id], unique: true
  end
end
