# frozen_string_literal: true

class ChangeOriginalPanelNull < ActiveRecord::Migration[5.1]
  def up
    oplus = Panel.find_by(name: 'OPlus')

    Panelist.where(original_panel: nil).find_each do |panelist|
      panelist.update_attributes(original_panel: oplus)
    end

    change_column_null :panelists, :original_panel_id, false
  end

  def down
    change_column_null :panelists, :original_panel_id, true
  end
end
