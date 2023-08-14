# frozen_string_literal: true

class RenameApiSurveyTargetsToSurveyApiTargets < ActiveRecord::Migration[5.1]
  def change
    rename_table :api_survey_targets, :survey_api_targets
  end
end
