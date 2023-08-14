# frozen_string_literal: true

class AddMoreIndexesToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_index :project_invitations, [:sample_batch_id, :panelist_id], unique: true
    add_index :project_invitations, [:survey_id, :panelist_id], unique: true
  end
end
