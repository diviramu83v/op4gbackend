# frozen_string_literal: true

class CreateDemoQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_queries do |t|
      t.references :panel, foreign_key: true
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
