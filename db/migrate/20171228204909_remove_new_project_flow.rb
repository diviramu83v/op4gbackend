# frozen_string_literal: true

class RemoveNewProjectFlow < ActiveRecord::Migration[5.1]
  def up
    drop_table :project_steps
    drop_table :project_step_patterns
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
