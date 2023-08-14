# frozen_string_literal: true

class AddApiSurveyTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :api_survey_targets do |t|
      t.integer :api_filter_min_age, null: false
      t.integer :api_filter_max_age, null: false
      t.string :api_filter_genders, array: true, null: false
      t.string :api_filter_countries, array: true, null: false
      t.string :status, null: false, default: 'active'

      t.references :survey, foreign_key: true, null: false

      t.timestamps
    end
  end
end
