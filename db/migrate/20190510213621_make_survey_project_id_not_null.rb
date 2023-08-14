# frozen_string_literal: true

class MakeSurveyProjectIdNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :surveys, :project_id, false
  end
end
