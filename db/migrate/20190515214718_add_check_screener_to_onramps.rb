# frozen_string_literal: true

class AddCheckScreenerToOnramps < ActiveRecord::Migration[5.1]
  def change
    add_column :onramps, :check_screener, :boolean, default: false, null: false
  end
end
