# frozen_string_literal: true

class AddPremiumToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :premium, :boolean
  end
end
