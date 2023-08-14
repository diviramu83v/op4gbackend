# frozen_string_literal: true

class CreateExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :expert_recruit_batches do |t|
      t.text :emails, null: false
      t.references :survey, foreign_key: true, null: false

      t.timestamps
    end
  end
end
