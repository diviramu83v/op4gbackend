# frozen_string_literal: true

class AddActiveFlagToSurveyParticipant < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_participants, :active, :boolean, null: false, default: true
  end
end
