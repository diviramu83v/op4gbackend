# frozen_string_literal: true

class AddHasPrescreenerFailuresToOnramps < ActiveRecord::Migration[5.2]
  def change
    add_column :onramps, :has_prescreener_failures, :boolean
  end
end
