# frozen_string_literal: true

class AddClickedAtToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :clicked_at, :datetime
  end
end
