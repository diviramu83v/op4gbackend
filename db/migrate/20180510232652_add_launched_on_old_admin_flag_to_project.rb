# frozen_string_literal: true

class AddLaunchedOnOldAdminFlagToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :running_on_old_admin, :boolean, null: false, default: false
  end
end
