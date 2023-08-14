# frozen_string_literal: true

class RemoveImportedDataFromPanelists < ActiveRecord::Migration[5.2]
  def change
    remove_column :panelists, :imported_data, :text
  end
end
