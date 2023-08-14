# frozen_string_literal: true

class AddCheckPrescreenerToOnramps < ActiveRecord::Migration[5.2]
  def change
    add_column :onramps, :check_prescreener, :boolean
  end
end
