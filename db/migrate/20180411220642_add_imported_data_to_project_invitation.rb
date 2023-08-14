# frozen_string_literal: true

class AddImportedDataToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :project_invitations, :imported_data, :text
  end
end
