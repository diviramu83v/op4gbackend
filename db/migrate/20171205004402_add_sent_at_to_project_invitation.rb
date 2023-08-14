# frozen_string_literal: true

class AddSentAtToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :sent_at, :datetime
  end
end
