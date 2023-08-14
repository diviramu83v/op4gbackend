# frozen_string_literal: true

class AddVendorToApiToken < ActiveRecord::Migration[5.1]
  def up
    ApiToken.delete_all
    add_reference :api_tokens, :vendor, null: false, foreign_key: true
  end

  def down
    remove_reference :api_tokens, :vendor, foreign_key: true
  end
end
