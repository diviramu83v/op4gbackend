# frozen_string_literal: true

class CreateSurveyResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_responses do |t|
      t.references :survey,                  foreign_key: true, null: false
      t.references :survey_response_pattern, foreign_key: true, null: false

      t.timestamps
    end
  end
end
