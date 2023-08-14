# frozen_string_literal: true

class AddLockFlagToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :lock_flag, :boolean
  end
end
