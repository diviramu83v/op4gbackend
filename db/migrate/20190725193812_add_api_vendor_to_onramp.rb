# frozen_string_literal: true

class AddApiVendorToOnramp < ActiveRecord::Migration[5.1]
  def change
    remove_reference :onramps, :api_token, foreign_key: true
    add_reference :onramps, :api_vendor, foreign_key: { to_table: :vendors }
  end
end
