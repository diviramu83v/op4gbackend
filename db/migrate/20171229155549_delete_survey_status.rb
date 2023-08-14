# frozen_string_literal: true

class DeleteSurveyStatus < ActiveRecord::Migration[5.1]
  def up
    remove_column :surveys, :survey_status_id
    remove_column :survey_participants, :survey_status_id
    drop_table :survey_statuses
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
