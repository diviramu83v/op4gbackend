# frozen_string_literal: true

class AddMultipleProjectStatusesToOnboarding < ActiveRecord::Migration[5.1]
  def change
    remove_column :onboardings, :project_status_id, :integer
    add_reference :onboardings, :initial_project_status, foreign_key: { to_table: :project_statuses }
    add_reference :onboardings, :final_project_status, foreign_key: { to_table: :project_statuses }
  end
end
