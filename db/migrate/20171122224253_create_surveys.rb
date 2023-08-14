# frozen_string_literal: true

class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.references :project, foreign_key: true
      t.string :base_link, null: false

      t.timestamps
    end
  end
end
