# frozen_string_literal: true

class AddPassedColumnToScreenerCheck < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_checks, :passed, :boolean, null: false, default: false
  end
end
