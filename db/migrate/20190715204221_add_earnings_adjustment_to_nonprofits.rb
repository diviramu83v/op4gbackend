# frozen_string_literal: true

class AddEarningsAdjustmentToNonprofits < ActiveRecord::Migration[5.1]
  def change
    add_column :nonprofits, :earning_adjustment_cents, :integer, default: 0, null: false
  end
end
