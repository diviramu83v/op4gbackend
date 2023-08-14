# frozen_string_literal: true

class AddUrlToRecontactInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :recontact_invitations, :url, :string
  end
end
