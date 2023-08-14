# frozen_string_literal: true

class AddCustomToScreenerSetups < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_setups, :custom, :boolean, default: false
    add_column :screener_setups, :custom_answer_bank, :string, array: true, default: []
  end
end
