# frozen_string_literal: true

class AddDescriptionToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    change_table :expert_recruit_batches, bulk: true do |t|
      t.string :description
      t.text :email_wording
    end
  end
end
