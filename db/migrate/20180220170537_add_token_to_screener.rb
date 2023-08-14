# frozen_string_literal: true

class AddTokenToScreener < ActiveRecord::Migration[5.1]
  def change
    # Add new column.
    add_column :screeners, :token, :string

    # Make sure token value is unique.
    add_index :screeners, :token, unique: true

    # Update null token values.
    # Screener.find_each(&:regenerate_token)

    # Don't allow null values.
    change_column_null(:screeners, :token, false)
  end
end
