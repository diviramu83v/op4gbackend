# frozen_string_literal: true

class RemoveImportedDataFromClients < ActiveRecord::Migration[5.2]
  def change
    remove_column :clients, :imported_data, :text
  end
end
