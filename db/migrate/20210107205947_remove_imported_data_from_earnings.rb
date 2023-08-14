# frozen_string_literal: true

class RemoveImportedDataFromEarnings < ActiveRecord::Migration[5.2]
  def change
    remove_column :earnings, :imported_data, :text
  end
end
