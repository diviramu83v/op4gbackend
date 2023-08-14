# frozen_string_literal: true

class AddStatesToSurveyApiTarget < ActiveRecord::Migration[5.1]
  def up
    add_column :survey_api_targets, :states, :string, array: true
  end

  def down
    remove_column :survey_api_targets, :states
  end
end
