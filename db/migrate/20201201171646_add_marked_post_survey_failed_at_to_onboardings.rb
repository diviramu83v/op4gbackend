# frozen_string_literal: true

class AddMarkedPostSurveyFailedAtToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :marked_post_survey_failed_at, :datetime
  end
end
