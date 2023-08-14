# frozen_string_literal: true

class AddPanelToEarnings < ActiveRecord::Migration[5.1]
  def change
    add_reference :earnings, :panel, foreign_key: true
    add_column :panels, :incentive_cents, :integer
  end
end
