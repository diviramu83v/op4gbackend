# frozen_string_literal: true

class RemoveCheckScreenerFromOnramps < ActiveRecord::Migration[5.2]
  def change
    remove_column :onramps, :check_screener, :boolean
  end
end
