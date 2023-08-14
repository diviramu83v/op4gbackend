# frozen_string_literal: true

class AddHashingFlagToVendor < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :include_hashing_param_in_hash_data, :boolean
  end
end
