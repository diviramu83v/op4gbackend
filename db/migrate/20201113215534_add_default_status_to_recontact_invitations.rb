# frozen_string_literal: true

class AddDefaultStatusToRecontactInvitations < ActiveRecord::Migration[5.2]
  def change
    change_column_default 'recontact_invitations', :status, from: nil, to: 'unsent'
  end
end
