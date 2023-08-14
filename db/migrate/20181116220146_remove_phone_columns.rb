# frozen_string_literal: true

class RemovePhoneColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :onramps, :check_phone_number

    remove_column :panelists, :phone
    remove_column :panelists, :phone_verification_code
    remove_column :panelists, :phone_verified_at
  end
end
