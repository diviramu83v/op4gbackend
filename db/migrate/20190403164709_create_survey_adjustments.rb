# frozen_string_literal: true

class CreateSurveyAdjustments < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_adjustments do |t|
      t.references :survey, foreign_key: true, null: false
      t.integer :complete_count, null: false

      t.timestamps
    end
  end
end
