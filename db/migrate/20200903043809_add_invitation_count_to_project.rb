# frozen_string_literal: true

class AddInvitationCountToProject < ActiveRecord::Migration[5.2]
  def change
    return if column_exists? :projects, :deleted_sent_invitations_count

    add_column :projects, :deleted_sent_invitations_count, :integer
  end
end
