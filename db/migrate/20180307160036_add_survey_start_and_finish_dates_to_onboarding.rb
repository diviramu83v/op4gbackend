# frozen_string_literal: true

class AddSurveyStartAndFinishDatesToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :survey_started_at, :datetime
    add_column :onboardings, :survey_finished_at, :datetime
  end
end
