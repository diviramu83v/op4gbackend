# frozen_string_literal: true

class AddLegacyEarningsToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :legacy_earnings_cents, :integer, null: false, default: 0
  end
end
