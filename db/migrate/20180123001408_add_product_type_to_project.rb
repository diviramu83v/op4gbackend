# frozen_string_literal: true

class AddProductTypeToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :product_type, foreign_key: true
  end
end
