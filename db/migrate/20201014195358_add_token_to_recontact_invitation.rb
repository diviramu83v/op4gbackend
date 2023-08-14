# frozen_string_literal: true

class AddTokenToRecontactInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :recontact_invitations, :token, :string, null: false
  end
end
