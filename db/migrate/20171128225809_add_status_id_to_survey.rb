# frozen_string_literal: true

class AddStatusIdToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_reference :surveys, :survey_status, foreign_key: true, null: false
  end
end
