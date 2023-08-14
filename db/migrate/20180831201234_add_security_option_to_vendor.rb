# frozen_string_literal: true

class AddSecurityOptionToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :security_disabled_by_default, :boolean, null: false, default: false
  end
end
