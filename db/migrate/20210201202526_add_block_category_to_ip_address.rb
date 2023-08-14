# frozen_string_literal: true

class AddBlockCategoryToIpAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :ip_addresses, :block_category, :string
  end
end
