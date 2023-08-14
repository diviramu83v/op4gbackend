# frozen_string_literal: true

class AddBypassTokenToOnramp < ActiveRecord::Migration[5.1]
  def change
    # Add new column.
    add_column :onramps, :bypass_token, :string

    # Make sure token value is unique.
    add_index :onramps, :bypass_token, unique: true

    # Update null token values.
    Onramp.find_each(&:regenerate_bypass_token)

    # Don't allow null values.
    change_column_null(:onramps, :bypass_token, false)
  end
end
