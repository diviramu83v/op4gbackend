# frozen_string_literal: true

class SetCheckPrescreenerToNullFalseOnOnramps < ActiveRecord::Migration[5.2]
  def change
    change_column_null :onramps, :check_prescreener, false
  end
end
