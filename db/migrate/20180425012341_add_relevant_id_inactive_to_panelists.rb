# frozen_string_literal: true

class AddRelevantIdInactiveToPanelists < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :relevant_id_score, :integer
    add_column :panelists, :fraud_profile_score, :integer
    add_column :panelists, :inactive, :datetime
  end
end
