# frozen_string_literal: true

class CreateDemoQueryDmas < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_dmas do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :dma, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_dmas, [:demo_query_id, :dma_id], unique: true
  end
end
