# frozen_string_literal: true

class AddHashingParamToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :hashing_param, :string
  end
end
