# frozen_string_literal: true

class DropDecodedDisqoProjects < ActiveRecord::Migration[6.1]
  def up
    drop_table :decoded_disqo_projects
    drop_table :disqo_project_decodings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
