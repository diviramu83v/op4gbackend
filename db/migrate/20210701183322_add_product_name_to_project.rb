# frozen_string_literal: true

class AddProductNameToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :product_name, :string
  end
end
