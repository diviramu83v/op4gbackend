# frozen_string_literal: true

class AddSortOrderToProjectStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :project_statuses, :sort, :integer, null: false, default: 0
  end
end
