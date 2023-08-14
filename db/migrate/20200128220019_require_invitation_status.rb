# frozen_string_literal: true

class RequireInvitationStatus < ActiveRecord::Migration[5.1]
  def up
    change_column :project_invitations, :status, :string, null: false
  end

  def down
    change_column :project_invitations, :status, :string, null: true
  end
end
