# frozen_string_literal: true

class RenameOnboardingInitialProjectCurrentStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :onboardings, :initial_project_current_status, :initial_project_status
  end
end
