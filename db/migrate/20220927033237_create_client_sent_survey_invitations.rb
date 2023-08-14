# frozen_string_literal: true

class CreateClientSentSurveyInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :client_sent_survey_invitations do |t|
      t.string :email, null: false
      t.boolean :opt_in, default: false
      t.references :onramp, foreign_key: true, null: false
      t.string :token, index: { unique: true }
      t.string :status, default: 'initialized', null: false
      t.timestamp :clicked_at

      t.timestamps
    end
  end
end
