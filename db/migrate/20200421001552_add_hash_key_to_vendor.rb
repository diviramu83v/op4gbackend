# frozen_string_literal: true

class AddHashKeyToVendor < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :hash_key, :string
  end
end
