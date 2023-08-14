# frozen_string_literal: true

class CreatePanelMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :panel_memberships do |t|
      t.references :panel, foreign_key: true, null: false
      t.references :panelist, foreign_key: true, null: false

      t.timestamps
    end
  end
end
