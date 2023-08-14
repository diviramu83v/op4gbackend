# frozen_string_literal: true

class RemoveFinalProjectStatusIdFromOnboardings < ActiveRecord::Migration[5.2]
  def up
    remove_column :onboardings, :final_project_status_id, :bigint
  end
end
