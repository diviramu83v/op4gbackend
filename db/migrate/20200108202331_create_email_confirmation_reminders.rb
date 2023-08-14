# frozen_string_literal: true

class CreateEmailConfirmationReminders < ActiveRecord::Migration[5.1]
  def change
    create_table :email_confirmation_reminders do |t|
      t.references :panelist, foreign_key: true, null: false
      t.datetime :send_at, null: false
      t.string :status, null: false, default: 'waiting'

      t.timestamps
    end
  end
end
