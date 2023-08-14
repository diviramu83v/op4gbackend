# frozen_string_literal: true

class RemoveSurveyStartModel < ActiveRecord::Migration[5.1]
  def change
    drop_table :survey_starts do |t|
      t.references :survey, foreign_key: true, null: false
      t.references :panelist, foreign_key: true, null: false

      t.timestamps
    end
  end
end
