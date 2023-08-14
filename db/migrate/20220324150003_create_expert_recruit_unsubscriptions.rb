# frozen_string_literal: true

class CreateExpertRecruitUnsubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :expert_recruit_unsubscriptions do |t|
      t.string :email
      t.references :expert_recruit

      t.timestamps
    end
  end
end
