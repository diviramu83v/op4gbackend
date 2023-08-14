# frozen_string_literal: true

class AddSurveyResponseToOnboarding < ActiveRecord::Migration[5.2]
  def change
    add_reference :onboardings, :initial_response, foreign_key: { to_table: :survey_responses }
  end
end
