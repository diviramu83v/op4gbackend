# frozen_string_literal: true

class IndexRecontactInvitationsOnToken < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :recontact_invitations, :token, algorithm: :concurrently, unique: true
  end
end
