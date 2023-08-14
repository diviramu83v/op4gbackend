# frozen_string_literal: true

class AddAgeRangeToApiSurveyTargets < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_api_targets, :api_filter_age_range, :integer, array: true, default: []
    remove_column :survey_api_targets, :api_filter_min_age, :integer
    remove_column :survey_api_targets, :api_filter_max_age, :integer
  end
end
