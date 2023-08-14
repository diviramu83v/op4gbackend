# frozen_string_literal: true

class AddReminderFieldsToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    change_table :expert_recruit_batches, bulk: true do |t|
      t.datetime :reminders_started_at
      t.datetime :reminders_finished_at
    end
  end
end
