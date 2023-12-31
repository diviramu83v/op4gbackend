# frozen_string_literal: true

class AddCategoryToIpAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :ip_addresses, :category, :string
  end
end
