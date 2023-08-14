# frozen_string_literal: true

class AddProjectIdToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_reference :surveys, :project, foreign_key: true
  end
end
