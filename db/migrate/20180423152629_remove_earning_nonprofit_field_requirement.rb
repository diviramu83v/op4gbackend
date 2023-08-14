# frozen_string_literal: true

class RemoveEarningNonprofitFieldRequirement < ActiveRecord::Migration[5.1]
  def change
    change_column_null :earnings, :nonprofit_id, true
  end
end
