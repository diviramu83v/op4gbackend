# frozen_string_literal: true

class RemoveSurveyParticipantTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :survey_participants do |t|
      t.bigint 'survey_response_id', null: false
      t.bigint 'panelist_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.boolean 'active', default: true, null: false
      t.bigint 'project_status_id', null: false
      t.integer 'sample_batch_id'
    end
  end
end
