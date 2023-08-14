# frozen_string_literal: true

class CreateRecontactInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :recontact_invitations do |t|
      t.references :recontact_invitation_batch, foreign_key: true, null: false
      t.string :uid, null: false
      t.references :onboarding, foreign_key: true, null: false

      t.timestamps
    end
  end
end
