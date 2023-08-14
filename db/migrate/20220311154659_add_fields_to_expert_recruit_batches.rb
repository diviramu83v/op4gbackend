# frozen_string_literal: true

class AddFieldsToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    change_table :expert_recruit_batches, bulk: true do |t|
      t.string :first_name
      t.integer :time
      t.references :employee, foreign_key: true
    end
  end
end
