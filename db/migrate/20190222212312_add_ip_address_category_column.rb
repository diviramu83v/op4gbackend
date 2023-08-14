# frozen_string_literal: true

class AddIpAddressCategoryColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :ip_addresses, :category, :string
    add_column :ip_addresses, :category, :string, null: false, default: 'allow'

    add_index :ip_addresses, :category
  end
end
