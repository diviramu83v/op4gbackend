# frozen_string_literal: true

class RemoveImportedDataFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :imported_data, :text
  end
end
