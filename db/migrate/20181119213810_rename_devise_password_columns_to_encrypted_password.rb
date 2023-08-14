# frozen_string_literal: true

class RenameDevisePasswordColumnsToEncryptedPassword < ActiveRecord::Migration[5.1]
  def change
    rename_column :panelists, :password, :encrypted_password
    rename_column :employees, :password, :encrypted_password
  end
end
