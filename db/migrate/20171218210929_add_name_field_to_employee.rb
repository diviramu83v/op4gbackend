# frozen_string_literal: true

class AddNameFieldToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :first_name, :string, null: false
    add_column :employees, :last_name, :string, null: false
  end
end
