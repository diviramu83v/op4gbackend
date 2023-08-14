# frozen_string_literal: true

class RemoveProductForeignKeyFromProject < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :projects, :products
  end
end
