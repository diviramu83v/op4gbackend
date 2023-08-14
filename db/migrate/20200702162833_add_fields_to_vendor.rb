# frozen_string_literal: true

class AddFieldsToVendor < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :contact_info, :text
  end
end
