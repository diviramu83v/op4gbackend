# frozen_string_literal: true

class AddActiveToProjectTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :project_types, :active, :boolean, null: false, default: false
  end
end
