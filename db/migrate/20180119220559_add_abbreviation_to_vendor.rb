# frozen_string_literal: true

class AddAbbreviationToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :abbreviation, :string
  end
end
