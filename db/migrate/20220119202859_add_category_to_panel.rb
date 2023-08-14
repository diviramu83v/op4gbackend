# frozen_string_literal: true

class AddCategoryToPanel < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :panels, :category, :string, default: 'standard', null: false
  end
end
