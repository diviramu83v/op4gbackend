# frozen_string_literal: true

class ChangeInitialResponseToSurveyResponseOnOnboarding < ActiveRecord::Migration[5.2]
  def change
    rename_column :onboardings, :initial_response_id, :survey_response_id
  end
end
