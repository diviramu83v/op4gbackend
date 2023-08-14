# frozen_string_literal: true

class DropUnusedTables < ActiveRecord::Migration[5.2]
  def up
    drop_table :sample_types
    drop_table :project_types
    drop_table :products
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
