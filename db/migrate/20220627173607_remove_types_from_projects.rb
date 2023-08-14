# frozen_string_literal: true

class RemoveTypesFromProjects < ActiveRecord::Migration[6.1]
  def up
    change_table :projects, bulk: true do |t|
      t.remove :project_type
      t.remove :sample_type
    end
  end

  def down
    change_table :projects, bulk: true do |t|
      t.string :project_type
      t.string :sample_type
    end
  end
end
