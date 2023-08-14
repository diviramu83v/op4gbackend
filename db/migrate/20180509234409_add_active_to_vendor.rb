# frozen_string_literal: true

class AddActiveToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :active, :boolean, null: false, default: true
  end
end
