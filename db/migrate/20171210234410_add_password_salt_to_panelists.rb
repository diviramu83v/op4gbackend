# frozen_string_literal: true

class AddPasswordSaltToPanelists < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :password_salt, :string
    rename_column :panelists, :encrypted_password, :password
  end
end
