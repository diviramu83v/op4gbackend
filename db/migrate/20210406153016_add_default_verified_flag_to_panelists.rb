# frozen_string_literal: true

class AddDefaultVerifiedFlagToPanelists < ActiveRecord::Migration[5.2]
  def change
    change_column_default :panelists, :verified_flag, from: nil, to: false
  end
end
