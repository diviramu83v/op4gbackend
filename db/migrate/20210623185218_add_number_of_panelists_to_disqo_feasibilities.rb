# frozen_string_literal: true

# this adds the feasibility column to the disqo feasibilities table
class AddNumberOfPanelistsToDisqoFeasibilities < ActiveRecord::Migration[5.2]
  def change
    add_column :disqo_feasibilities, :number_of_panelists, :integer
  end
end
