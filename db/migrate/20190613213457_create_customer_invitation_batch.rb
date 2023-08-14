# frozen_string_literal: true

class CreateCustomerInvitationBatch < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_invitation_batches do |t|
      t.integer :count, null: false
      t.datetime :sent_at
      t.string :email_subject, null: false
      t.text :description
      t.datetime :closed_at
      t.datetime :invitations_created_at
      t.references :customer_survey, foreign_key: true, null: false

      t.timestamps
    end

    add_reference :customer_survey_invitations, :customer_invitation_batch, null: false, foreign_key: true, index: { name: :customer_batch }
  end
end
