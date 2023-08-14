# frozen_string_literal: true

class AddActiveToProjectStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :project_statuses, :active, :boolean, null: false, default: false
  end
end
