# frozen_string_literal: true

class RenameStatusHolderOnPanelists < ActiveRecord::Migration[5.1]
  def change
    rename_column :panelists, :status_holder, :status
  end
end
