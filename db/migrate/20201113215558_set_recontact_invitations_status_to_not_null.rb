# frozen_string_literal: true

class SetRecontactInvitationsStatusToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :recontact_invitations, :status, false
  end
end
