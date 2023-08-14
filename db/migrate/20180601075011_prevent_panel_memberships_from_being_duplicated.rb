# frozen_string_literal: true

class PreventPanelMembershipsFromBeingDuplicated < ActiveRecord::Migration[5.1]
  def change
    add_index :panel_memberships, [:panel_id, :panelist_id], unique: true
  end
end
