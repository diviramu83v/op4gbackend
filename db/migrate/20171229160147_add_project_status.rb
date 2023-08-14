# frozen_string_literal: true

class AddProjectStatus < ActiveRecord::Migration[5.1]
  def change
    create_table :project_statuses do |t|
      t.string :slug, null: false
      t.boolean :default, null: false, default: false

      t.timestamps
    end

    add_index :project_statuses, :slug, unique: true

    add_reference :projects, :project_status, foreign_key: true, null: false
    add_reference :survey_participants, :project_status, foreign_key: true, null: false
  end
end
