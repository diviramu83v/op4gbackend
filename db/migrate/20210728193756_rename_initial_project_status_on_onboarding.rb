# frozen_string_literal: true

class RenameInitialProjectStatusOnOnboarding < ActiveRecord::Migration[5.2]
  def change
    rename_column :onboardings, :initial_project_status, :initial_survey_status
  end
end
