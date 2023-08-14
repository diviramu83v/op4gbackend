# frozen_string_literal: true

class AddDefaultToProjectInvitationStatus < ActiveRecord::Migration[5.1]
  def up
    change_column_default :project_invitations, :status, 'initialized'
  end

  def down
    change_column_default :project_invitations, :status, nil
  end
end
