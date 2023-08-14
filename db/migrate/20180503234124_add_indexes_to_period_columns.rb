# frozen_string_literal: true

class AddIndexesToPeriodColumns < ActiveRecord::Migration[5.1]
  def change
    add_index :earnings, :period
    add_index :earnings, :period_year
    add_index :payments, :period
    add_index :payments, :period_year
  end
end
