# frozen_string_literal: true

# this changes the panelist's score default value to nil
class ChangeDefaultScoreForPanelists < ActiveRecord::Migration[5.2]
  def change
    change_column_default :panelists, :score, from: 0, to: nil
  end
end
