# frozen_string_literal: true

class RemoveNullRequirementFromSurveyLink < ActiveRecord::Migration[5.1]
  def change
    change_column_null :surveys, :base_link, true
  end
end
