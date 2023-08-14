# frozen_string_literal: true

class CreateDemoQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_questions do |t|
      t.references :panel, foreign_key: true, null: false
      t.references :country, foreign_key: true
      t.string :input_type, null: false
      t.integer :sort_order, null: false
      t.string :label, null: false
      t.string :import_label, null: false

      t.timestamps
    end
  end
end
