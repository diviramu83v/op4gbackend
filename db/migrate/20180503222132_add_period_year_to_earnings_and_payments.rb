# frozen_string_literal: true

class AddPeriodYearToEarningsAndPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :earnings, :period_year, :string
    add_column :payments, :period_year, :string
  end
end
