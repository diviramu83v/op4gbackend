# frozen_string_literal: true

class CreateRecontactInvitationBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :recontact_invitation_batches do |t|
      t.text :encoded_uids, null: false
      t.string :status, null: false, default: 'initialized'
      t.references :recontact, foreign_key: true

      t.timestamps
    end
  end
end
