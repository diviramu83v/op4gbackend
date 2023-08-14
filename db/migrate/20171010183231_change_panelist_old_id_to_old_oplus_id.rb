# frozen_string_literal: true

class ChangePanelistOldIdToOldOplusId < ActiveRecord::Migration[5.1]
  def change
    rename_column :panelists, :old_id, :oplus_id
  end
end
