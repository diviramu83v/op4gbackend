# frozen_string_literal: true

class AddFinishedAtToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :finished_at, :datetime
  end
end
