# frozen_string_literal: true

class AddPremiumStatusToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :premium_status, :string
  end
end
