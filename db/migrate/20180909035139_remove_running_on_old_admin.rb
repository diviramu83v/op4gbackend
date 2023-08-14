# frozen_string_literal: true

class RemoveRunningOnOldAdmin < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :running_on_old_admin, :boolean
  end
end
