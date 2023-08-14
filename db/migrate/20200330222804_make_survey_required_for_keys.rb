# frozen_string_literal: true

class MakeSurveyRequiredForKeys < ActiveRecord::Migration[5.1]
  def change
    change_column_null :keys, :survey_id, false
  end
end
