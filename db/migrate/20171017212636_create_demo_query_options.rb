# frozen_string_literal: true

class CreateDemoQueryOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_options do |t|
      t.references :demo_query, foreign_key: true
      t.references :demo_option, foreign_key: true

      t.timestamps
    end
  end
end
