# frozen_string_literal: true

class AddVerifiedFlagToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :verified_flag, :boolean
  end
end
