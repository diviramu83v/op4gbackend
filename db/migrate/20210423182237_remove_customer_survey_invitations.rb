# frozen_string_literal: true

# This removes the 'customer_survey_invitations' table
class RemoveCustomerSurveyInvitations < ActiveRecord::Migration[5.2]
  def change
    drop_table :customer_survey_invitations do |t|
      t.bigint :panelist_id, null: false
      t.datetime :sent_at
      t.datetime :clicked_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.bigint :customer_invitation_batch_id, null: false
      t.string :status, default: 'initialized', null: false
      t.index :customer_invitation_batch_id, name: 'customer_batch'
      t.index :panelist_id, name: 'index_customer_survey_invitations_on_panelist_id'
    end
  end
end
