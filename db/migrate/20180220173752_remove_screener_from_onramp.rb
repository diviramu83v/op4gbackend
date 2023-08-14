# frozen_string_literal: true

class RemoveScreenerFromOnramp < ActiveRecord::Migration[5.1]
  def change
    remove_reference :onramps, :screener, foreign_key: true
  end
end
