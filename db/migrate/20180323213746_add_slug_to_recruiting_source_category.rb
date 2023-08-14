# frozen_string_literal: true

class AddSlugToRecruitingSourceCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :recruiting_source_categories, :slug, :string

    change_column_null(:recruiting_source_categories, :slug, false)
    change_column_null(:recruiting_source_categories, :name, false)

    add_index :recruiting_source_categories, :slug, unique: true
    add_index :recruiting_source_categories, :name, unique: true
  end
end
