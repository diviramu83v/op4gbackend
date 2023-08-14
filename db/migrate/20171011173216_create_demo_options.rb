# frozen_string_literal: true

class CreateDemoOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_options do |t|
      t.references :demo_question, foreign_key: true, null: false
      t.string :label, null: false

      t.timestamps
    end
  end
end
