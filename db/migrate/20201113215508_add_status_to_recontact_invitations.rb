# frozen_string_literal: true

class AddStatusToRecontactInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :recontact_invitations, :status, :string
  end
end
