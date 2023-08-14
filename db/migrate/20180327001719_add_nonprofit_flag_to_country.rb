# frozen_string_literal: true

class AddNonprofitFlagToCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :nonprofit_flag, :boolean, null: false, default: false
  end
end
