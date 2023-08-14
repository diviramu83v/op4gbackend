# frozen_string_literal: true

class AddStatusToProjectInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :status, :string
    add_column :project_invitations, :rejected_at, :datetime
    add_column :project_invitations, :paid_at, :datetime
  end
end
