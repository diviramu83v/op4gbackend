# frozen_string_literal: true

class AddSlugToDemoQueryProjectInclusions < ActiveRecord::Migration[5.2]
  def change
    add_column :demo_query_project_inclusions, :slug, :string
  end
end
