# frozen_string_literal: true

class RenameOnboardingsSurveyResponseIdAndIndex < ActiveRecord::Migration[5.2]
  def change
    rename_index :onboardings, 'index_onboardings_on_survey_response_id', 'index_onboardings_on_survey_response_url_id'
    rename_column :onboardings, :survey_response_id, :survey_response_url_id
  end
end
