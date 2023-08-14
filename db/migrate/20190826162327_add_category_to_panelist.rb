# frozen_string_literal: true

class AddCategoryToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :category, :string, null: false, default: Panelist.categories[:internal]
  end
end
