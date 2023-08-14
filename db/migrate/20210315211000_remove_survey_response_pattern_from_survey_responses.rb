# frozen_string_literal: true

class RemoveSurveyResponsePatternFromSurveyResponses < ActiveRecord::Migration[5.2]
  def up
    remove_column :survey_response_urls, :survey_response_pattern_id
  end

  def down
    add_reference :survey_response_urls, :survey_response_pattern_id, foreign_key: true
  end
end
