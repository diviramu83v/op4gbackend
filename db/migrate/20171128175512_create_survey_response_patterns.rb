# frozen_string_literal: true

class CreateSurveyResponsePatterns < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_response_patterns do |t|
      t.string :slug,  null: false
      t.string :name,  null: false
      t.integer :sort, null: false

      t.timestamps
    end
  end
end
