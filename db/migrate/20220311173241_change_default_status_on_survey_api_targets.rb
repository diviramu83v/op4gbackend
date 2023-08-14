# frozen_string_literal: true

class ChangeDefaultStatusOnSurveyApiTargets < ActiveRecord::Migration[5.2]
  def change
    change_column_default :survey_api_targets, :status, from: 'active', to: 'inactive'
  end
end
