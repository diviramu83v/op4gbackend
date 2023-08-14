# frozen_string_literal: true

class CreateSurveyWarnings < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_warnings do |t|
      t.string :category, default: SurveyWarning.categories[:unfiltered], null: false
      t.references :survey, null: false
      t.references :sample_batch
      t.string :status, default: SurveyWarning.statuses[:active], null: false

      t.timestamps
    end
  end
end
