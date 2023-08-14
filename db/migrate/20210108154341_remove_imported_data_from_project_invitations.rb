# frozen_string_literal: true

class RemoveImportedDataFromProjectInvitations < ActiveRecord::Migration[5.2]
  def change
    remove_column :project_invitations, :imported_data, :text
  end
end
