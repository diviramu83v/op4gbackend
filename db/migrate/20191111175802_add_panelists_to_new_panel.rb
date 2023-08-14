# frozen_string_literal: true

class AddPanelistsToNewPanel < ActiveRecord::Migration[5.1]
  def up
    new_panel = Panel.find_by(name: 'New_Op4G')
    panelists = Panelist.joins(:panel_memberships).where('panel_memberships.panel_id IN (?)', [1, 2]).where(status: %w[active signing_up])
    panelists = panelists.active.or(panelists.signing_up).distinct

    panelists.find_each do |panelist|
      PanelMembership.create(panel: new_panel, panelist: panelist)
    end
  end
end
