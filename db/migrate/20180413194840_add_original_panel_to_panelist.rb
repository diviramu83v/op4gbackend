# frozen_string_literal: true

class AddOriginalPanelToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_reference :panelists, :original_panel, foreign_key: { to_table: :panels }
  end
end
