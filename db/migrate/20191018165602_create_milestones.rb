# frozen_string_literal: true

class CreateMilestones < ActiveRecord::Migration[5.1]
  def change
    create_table :milestones do |t|
      t.integer :target_completes
      t.references :survey, null: false, foreign_key: true
      t.string :status, null: false, default: Milestone.statuses[:active]
      t.datetime :sent_at

      t.timestamps
    end
  end
end
