# frozen_string_literal: true

class RemoveProjectStatusIdFromProjects < ActiveRecord::Migration[5.2]
  def up
    remove_column :projects, :project_status_id, :bigint
  end
end
