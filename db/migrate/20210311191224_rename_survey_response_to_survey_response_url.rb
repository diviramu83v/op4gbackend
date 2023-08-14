# frozen_string_literal: true

class RenameSurveyResponseToSurveyResponseUrl < ActiveRecord::Migration[5.2]
  def up
    rename_table 'survey_responses', 'survey_response_urls'
  end

  def down
    rename_table 'survey_response_urls', 'survey_responses'
  end
end
