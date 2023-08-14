# frozen_string_literal: true

class AddSignupReminders < ActiveRecord::Migration[5.1]
  def change
    create_table :signup_reminders do |t|
      t.references :panelist, null: false
      t.datetime :send_at
      t.string :status, default: :waiting

      t.timestamps
    end
  end
end
