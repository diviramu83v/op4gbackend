# frozen_string_literal: true

class AddCategoryToEarnings < ActiveRecord::Migration[5.2]
  def change
    add_column :earnings, :category, :string
  end
end
