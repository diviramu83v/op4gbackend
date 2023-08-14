# frozen_string_literal: true

class AdjustProjectInvitationIndexes < ActiveRecord::Migration[5.1]
  def change
    remove_index :project_invitations, column: [:project_id, :panelist_id]
  end
end
