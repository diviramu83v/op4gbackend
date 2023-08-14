# frozen_string_literal: true

class RemovePanelIdFromPanelist < ActiveRecord::Migration[5.1]
  def change
    remove_column :panelists, :panel_id, :integer
  end
end
