# frozen_string_literal: true

class AddProjectToSurveyResponse < ActiveRecord::Migration[5.2]
  def change
    add_reference :survey_responses, :project, foreign_key: true
    change_column_null :survey_responses, :survey_id, true
  end
end
