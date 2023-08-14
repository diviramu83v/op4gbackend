# frozen_string_literal: true

class CreateSystemEventSummaries < ActiveRecord::Migration[5.1]
  def change
    create_table :system_event_summaries do |t|
      t.datetime :day_happened_at, null: false
      t.string :action, null: false
      t.integer :count, null: false

      t.timestamps
    end

    add_index :system_event_summaries, [:day_happened_at, :action], unique: true
  end
end
