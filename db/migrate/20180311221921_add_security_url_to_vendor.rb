# frozen_string_literal: true

class AddSecurityUrlToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :security_url, :string
  end
end
