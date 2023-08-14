# frozen_string_literal: true

# This removes the category column from the panels table
class RemoveCategoryColumnFromPanels < ActiveRecord::Migration[5.2]
  def change
    remove_column :panels, :category, :string
  end
end
