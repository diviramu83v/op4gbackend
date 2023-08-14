# frozen_string_literal: true

# This removes the category column from the panelists table
class RemoveCategoryColumnFromPanelists < ActiveRecord::Migration[5.2]
  def change
    remove_column :panelists, :category, :string
  end
end
