# frozen_string_literal: true

class AddCategoryColumnToPanel < ActiveRecord::Migration[5.1]
  def change
    add_column :panels, :category, :string, null: false, default: 'internal'
  end
end
