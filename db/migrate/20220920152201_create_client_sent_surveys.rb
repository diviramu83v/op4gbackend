# frozen_string_literal: true

class CreateClientSentSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :client_sent_surveys do |t|
      t.references :survey, foreign_key: true, null: false
      t.references :employee, foreign_key: true, null: false
      t.string :description
      t.string :email_subject
      t.text :landing_page_text
      t.integer :incentive_cents

      t.timestamps
    end
  end
end
