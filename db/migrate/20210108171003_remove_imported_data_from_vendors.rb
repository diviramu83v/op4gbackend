# frozen_string_literal: true

class RemoveImportedDataFromVendors < ActiveRecord::Migration[5.2]
  def change
    remove_column :vendors, :imported_data, :text
  end
end
