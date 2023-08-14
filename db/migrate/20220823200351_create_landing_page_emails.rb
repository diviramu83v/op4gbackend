# frozen_string_literal: true

class CreateLandingPageEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_page_emails do |t|
      t.string :email, null: false
      t.boolean :opt_in, default: false

      t.timestamps
    end
  end
end
