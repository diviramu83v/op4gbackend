# frozen_string_literal: true

class RemoveSurveyIdFromSurveyResponseUrls < ActiveRecord::Migration[5.2]
  def change
    remove_column :survey_response_urls, :survey_id, :bigint
  end
end
