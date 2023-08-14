# frozen_string_literal: true

class AddSlugToProjectStepPattern < ActiveRecord::Migration[5.1]
  def change
    add_column :project_step_patterns, :slug, :string, null: false
  end
end
