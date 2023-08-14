# frozen_string_literal: true

class ChangePrimaryPanelIdToNullFalse < ActiveRecord::Migration[5.1]
  def change
    change_column_null :panelists, :primary_panel_id, false
  end
end
