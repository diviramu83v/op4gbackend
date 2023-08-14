# frozen_string_literal: true

class AddProjectTypeProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :project_type, :string
  end
end
