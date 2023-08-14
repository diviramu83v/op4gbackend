# frozen_string_literal: true

class RemoveNullFalseFromInitialProjectStatusIdInOnboardings < ActiveRecord::Migration[5.2]
  def up
    change_column_null :onboardings, :initial_project_status_id, true
  end
end
