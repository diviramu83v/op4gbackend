# frozen_string_literal: true

class AddFieldsToRecontactInvitationBatch < ActiveRecord::Migration[5.2]
  def change
    add_column :recontact_invitation_batches, :incentive_cents, :integer
    add_column :recontact_invitation_batches, :subject, :string
    add_column :recontact_invitation_batches, :email_body, :text
  end
end
