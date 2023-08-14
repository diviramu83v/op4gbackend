# frozen_string_literal: true

class CreateSurveyParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_participants do |t|
      t.references :survey_response, foreign_key: true, null: false
      t.references :panelist, foreign_key: true

      t.timestamps
    end
  end
end
