# frozen_string_literal: true

class CreateSurveyTestModes < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_test_modes do |t|
      t.boolean :easy_test, null: false, default: false
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
