# frozen_string_literal: true

class CreateProjectInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :project_invitations do |t|
      t.references :project, foreign_key: true, null: false
      t.references :panelist, foreign_key: true, null: false
      t.references :sample_batch, foreign_key: true, null: false

      t.timestamps
    end

    add_index :project_invitations, [:project_id, :panelist_id], unique: true
  end
end
