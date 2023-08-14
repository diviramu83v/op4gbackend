# frozen_string_literal: true

# this adds a percentile column to the panelists table
class AddPercentileToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :score_percentile, :integer
  end
end
