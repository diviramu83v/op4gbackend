# frozen_string_literal: true

class AddSubjectAndStatusToExpertBatch < ActiveRecord::Migration[5.2]
  def change
    change_table :expert_recruit_batches, bulk: true do |t|
      t.string :status, default: 'waiting', null: false
      t.string :email_subject, default: 'Take this survey', null: false
    end
  end
end
