# frozen_string_literal: true

class RemoveImportedDataFromSurveys < ActiveRecord::Migration[5.2]
  def change
    remove_column :surveys, :imported_data, :text
  end
end
