# frozen_string_literal: true

# this adds a default value of '0' to the panelists score
class AddDefaultScoreToPanelists < ActiveRecord::Migration[5.2]
  def change
    change_column_default :panelists, :score, from: nil, to: 0
  end
end
