# frozen_string_literal: true

class RenameProjectCurrentStatusToStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :current_status, :status
  end
end
