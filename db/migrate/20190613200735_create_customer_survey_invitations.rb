# frozen_string_literal: true

class CreateCustomerSurveyInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_survey_invitations do |t|
      t.references :panelist, foreign_key: true, null: false
      t.datetime :sent_at
      t.datetime :clicked_at
      t.string :token, null: false

      t.timestamps
    end

    add_index :customer_survey_invitations, :token, unique: true
  end
end
