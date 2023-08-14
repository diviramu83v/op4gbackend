# frozen_string_literal: true

class AddDeclinedAtToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :declined_at, :datetime
  end
end
