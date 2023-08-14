# frozen_string_literal: true

class RemoveNullConstraintFromRecontactBatchesEncodedUids < ActiveRecord::Migration[5.2]
  def change
    change_column_null :recontact_invitation_batches, :encoded_uids, true
  end
end
