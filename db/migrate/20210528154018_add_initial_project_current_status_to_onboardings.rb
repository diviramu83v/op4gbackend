# frozen_string_literal: true

class AddInitialProjectCurrentStatusToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :initial_project_current_status, :string
  end
end
