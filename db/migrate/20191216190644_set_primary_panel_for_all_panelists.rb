# frozen_string_literal: true

class SetPrimaryPanelForAllPanelists < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    new_panel = Panel.find_by(name: 'New_Op4G')
    canada_panel = Panel.find_by(name: 'Op4G-CA')
    united_kingdom_panel = Panel.find_by(name: 'Op4G-UK')
    germany_panel = Panel.find_by(name: 'Op4G-DE')
    france_panel = Panel.find_by(name: 'Op4G-FR')
    spain_panel = Panel.find_by(name: 'Op4G-ES')
    italy_panel = Panel.find_by(name: 'Op4G-IT')
    australia_panel = Panel.find_by(name: 'Op4G-AU')

    new_panel.panelists.update_all(primary_panel_id: new_panel.id)
    canada_panel.panelists.update_all(primary_panel_id: canada_panel.id)
    united_kingdom_panel.panelists.update_all(primary_panel_id: united_kingdom_panel.id)
    germany_panel.panelists.update_all(primary_panel_id: germany_panel.id)
    france_panel.panelists.update_all(primary_panel_id: france_panel.id)
    spain_panel.panelists.update_all(primary_panel_id: spain_panel.id)
    italy_panel.panelists.update_all(primary_panel_id: italy_panel.id)
    australia_panel.panelists.update_all(primary_panel_id: australia_panel.id)

    Panelist.where(primary_panel_id: nil).find_each do |panelist|
      panelist.update_column(:primary_panel_id, panelist.original_panel_id)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
