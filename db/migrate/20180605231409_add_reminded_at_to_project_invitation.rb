# frozen_string_literal: true

class AddRemindedAtToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :reminded_at, :datetime
  end
end
