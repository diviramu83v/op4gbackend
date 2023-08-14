# frozen_string_literal: true

class AddDefaultLockFlagToPanelists < ActiveRecord::Migration[5.2]
  def change
    change_column_default :panelists, :lock_flag, false
  end
end
