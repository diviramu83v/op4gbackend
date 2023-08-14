# frozen_string_literal: true

class AddNonprofitContributionPercentageToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :nonprofit_contribution_percentage, :integer, null: false, default: 0
  end
end
