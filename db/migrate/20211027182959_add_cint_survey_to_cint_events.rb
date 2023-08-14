# frozen_string_literal: true

class AddCintSurveyToCintEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :cint_events, :cint_survey, foreign_key: true
  end
end
