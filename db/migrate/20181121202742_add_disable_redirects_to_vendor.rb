# frozen_string_literal: true

class AddDisableRedirectsToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :disable_redirects, :boolean, null: false, default: false
  end
end
