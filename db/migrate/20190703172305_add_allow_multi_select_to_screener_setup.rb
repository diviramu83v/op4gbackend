# frozen_string_literal: true

class AddAllowMultiSelectToScreenerSetup < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_setups, :allow_multi_select, :boolean, default: false, null: false
  end
end
