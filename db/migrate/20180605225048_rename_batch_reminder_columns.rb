# frozen_string_literal: true

class RenameBatchReminderColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :sample_batches, :reminder_started_at, :reminders_started_at
    rename_column :sample_batches, :reminder_finished_at, :reminders_finished_at
  end
end
