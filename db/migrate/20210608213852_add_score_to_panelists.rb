# frozen_string_literal: true

# this adds a score column to the panelists table
class AddScoreToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :score, :integer
  end
end
