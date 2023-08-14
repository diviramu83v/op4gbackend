# frozen_string_literal: true

class AddTokenToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :token, :string, null: false
    add_index :project_invitations, :token, unique: true
  end
end
