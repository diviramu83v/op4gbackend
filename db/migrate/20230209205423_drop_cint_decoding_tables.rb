# frozen_string_literal: true

class DropCintDecodingTables < ActiveRecord::Migration[6.1]
  def up
    drop_table :decoded_cint_projects
    drop_table :cint_project_decodings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
