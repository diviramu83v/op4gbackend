# frozen_string_literal: true

class AddScreenerToOnramp < ActiveRecord::Migration[5.1]
  def change
    add_reference :onramps, :screener, foreign_key: true
  end
end
