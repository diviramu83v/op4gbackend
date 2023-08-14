# frozen_string_literal: true

class AddUidParameterToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :uid_parameter, :string
  end
end
