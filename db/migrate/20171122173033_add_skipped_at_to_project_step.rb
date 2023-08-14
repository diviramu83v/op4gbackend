# frozen_string_literal: true

class AddSkippedAtToProjectStep < ActiveRecord::Migration[5.1]
  def change
    add_column :project_steps, :skipped_at, :datetime
  end
end
