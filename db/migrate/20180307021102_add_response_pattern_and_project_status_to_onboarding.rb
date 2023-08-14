# frozen_string_literal: true

class AddResponsePatternAndProjectStatusToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_reference :onboardings, :survey_response_pattern, foreign_key: true
    add_reference :onboardings, :project_status, foreign_key: true
  end
end
