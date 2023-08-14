# frozen_string_literal: true

class AddScreenerBooleanToOnramp < ActiveRecord::Migration[5.1]
  def change
    add_column :onramps, :use_screener, :boolean, null: false, default: false
  end
end
