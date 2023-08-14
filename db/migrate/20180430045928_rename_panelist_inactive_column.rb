# frozen_string_literal: true

class RenamePanelistInactiveColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :panelists, :inactive, :deactivated_at
  end
end
