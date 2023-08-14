# frozen_string_literal: true

class AddProductToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :product, foreign_key: true
  end
end
