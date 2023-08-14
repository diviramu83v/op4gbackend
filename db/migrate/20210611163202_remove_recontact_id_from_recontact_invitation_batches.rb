# frozen_string_literal: true

class RemoveRecontactIdFromRecontactInvitationBatches < ActiveRecord::Migration[5.2]
  def change
    remove_column :recontact_invitation_batches, :recontact_id, :bigint
  end
end
