# frozen_string_literal: true

class RemoveClosedAtFromProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    remove_column :project_invitations, :closed_at, :datetime
  end
end
