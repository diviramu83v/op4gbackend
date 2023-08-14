# frozen_string_literal: true

class AddSurveyStatusToSurveyParticipant < ActiveRecord::Migration[5.1]
  def change
    add_reference :survey_participants, :survey_status, foreign_key: true
  end
end
