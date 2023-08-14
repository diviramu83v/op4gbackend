# frozen_string_literal: true

class AddHiddenColumnsToEarningsAndPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :earnings, :hidden_at, :datetime
    add_column :payments, :hidden_at, :datetime
  end
end
