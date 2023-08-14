# frozen_string_literal: true

class AddAverageReactionTimeToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :average_reaction_time, :integer
  end
end
