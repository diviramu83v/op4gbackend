# frozen_string_literal: true

class RemoveStatusFromProjects < ActiveRecord::Migration[5.2]
  def up
    remove_column :projects, :status
  end

  def down
    add_column :projects, :status, :string, default: 'waiting'
  end
end
