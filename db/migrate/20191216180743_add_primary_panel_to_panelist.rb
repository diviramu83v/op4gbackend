# frozen_string_literal: true

class AddPrimaryPanelToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_reference :panelists, :primary_panel, foreign_key: { to_table: :panels }
  end
end
