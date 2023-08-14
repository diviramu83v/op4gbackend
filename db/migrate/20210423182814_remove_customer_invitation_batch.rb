# frozen_string_literal: true

# This removes the 'customer_survey_invitations' table
class RemoveCustomerInvitationBatch < ActiveRecord::Migration[5.2]
  def change
    drop_table :customer_invitation_batches do |t|
      t.integer :count, null: false
      t.datetime :sent_at
      t.string :email_subject, null: false
      t.text :description
      t.datetime :closed_at
      t.datetime :invitations_created_at
      t.bigint :customer_survey_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.bigint :demo_query_id
      t.string :status, default: 'initialized', null: false
      t.index :customer_survey_id, name: 'index_customer_invitation_batches_on_customer_survey_id'
      t.index :demo_query_id, name: 'index_customer_invitation_batches_on_demo_query_id'
    end
  end
end
