# frozen_string_literal: true

class AddIndexOnNameAndSlugOnPanels < ActiveRecord::Migration[5.1]
  def change
    add_index :panels, :name, unique: true
    add_index :panels, :slug, unique: true
  end
end
