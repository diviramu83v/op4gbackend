# frozen_string_literal: true

class AddSortToProjectStepPattern < ActiveRecord::Migration[5.1]
  def change
    add_column :project_step_patterns, :sort, :integer, null: false
  end
end
