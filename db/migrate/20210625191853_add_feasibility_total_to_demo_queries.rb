# frozen_string_literal: true

class AddFeasibilityTotalToDemoQueries < ActiveRecord::Migration[5.2]
  def change
    add_column :demo_queries, :feasibility_total, :integer
  end
end
