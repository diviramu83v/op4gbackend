# frozen_string_literal: true

class ChangeProductTypesToProjectTypes < ActiveRecord::Migration[5.1]
  def change
    remove_reference :projects, :product_type, foreign_key: true

    rename_table :product_types, :project_types

    add_reference :projects, :project_type, foreign_key: true
  end
end
