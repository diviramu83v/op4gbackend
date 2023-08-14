# frozen_string_literal: true

class SetSurveyNameToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :surveys, :name, false
  end
end
