# frozen_string_literal: true

class RemoveImportedDataFromPayments < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :imported_data, :text
  end
end
