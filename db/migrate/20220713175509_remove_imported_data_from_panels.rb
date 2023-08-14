# frozen_string_literal: true

class RemoveImportedDataFromPanels < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :panels, :imported_data, :text }
  end
end
