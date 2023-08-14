# frozen_string_literal: true

class AddOldIdToPanelists < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :old_id, :string
  end
end
