# frozen_string_literal: true

class AddClosedAtToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :closed_at, :datetime
  end
end
