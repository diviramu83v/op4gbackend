# frozen_string_literal: true

class RenameMilestonesToCompleteMilestones < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      rename_table :milestones, :complete_milestones
    end
  end
end
