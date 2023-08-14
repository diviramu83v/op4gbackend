# frozen_string_literal: true

class RemoveImportedDataFromNonprofits < ActiveRecord::Migration[5.2]
  def change
    remove_column :nonprofits, :imported_data, :text
  end
end
