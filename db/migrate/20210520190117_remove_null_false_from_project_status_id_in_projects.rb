# frozen_string_literal: true

class RemoveNullFalseFromProjectStatusIdInProjects < ActiveRecord::Migration[5.2]
  def up
    change_column_null :projects, :project_status_id, true
  end
end
