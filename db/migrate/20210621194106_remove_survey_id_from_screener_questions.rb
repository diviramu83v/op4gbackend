# frozen_string_literal: true

class RemoveSurveyIdFromScreenerQuestions < ActiveRecord::Migration[5.2]
  def change
    remove_column :screener_questions, :survey_id, :bigint
  end
end
