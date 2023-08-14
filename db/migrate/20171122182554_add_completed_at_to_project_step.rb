# frozen_string_literal: true

class AddCompletedAtToProjectStep < ActiveRecord::Migration[5.1]
  def change
    add_column :project_steps, :completed_at, :datetime
  end
end
