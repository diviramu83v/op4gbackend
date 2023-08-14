# frozen_string_literal: true

class CreateIncentiveRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :incentive_recipients do |t|
      t.string :email_address
      t.string :uid
      t.references :onboarding, foreign_key: true, null: false
      t.references :incentive_batch, foreign_key: true, null: false
      t.string :status, null: false, default: 'initialized'
      t.boolean :sent, null: false, default: false

      t.timestamps
    end
  end
end
