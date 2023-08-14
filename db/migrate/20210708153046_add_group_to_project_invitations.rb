# frozen_string_literal: true

class AddGroupToProjectInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :project_invitations, :group, :integer
  end
end
