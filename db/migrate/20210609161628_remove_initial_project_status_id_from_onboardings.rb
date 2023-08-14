# frozen_string_literal: true

class RemoveInitialProjectStatusIdFromOnboardings < ActiveRecord::Migration[5.2]
  def up
    remove_column :onboardings, :initial_project_status_id, :bigint
  end
end
