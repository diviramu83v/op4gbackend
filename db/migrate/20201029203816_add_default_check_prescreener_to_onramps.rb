# frozen_string_literal: true

class AddDefaultCheckPrescreenerToOnramps < ActiveRecord::Migration[5.2]
  def change
    change_column_default :onramps, :check_prescreener, from: nil, to: false
  end
end
