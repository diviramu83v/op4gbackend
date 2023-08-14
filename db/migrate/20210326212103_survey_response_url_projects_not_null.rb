# frozen_string_literal: true

class SurveyResponseUrlProjectsNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :survey_response_urls, :project_id, false
  end
end
