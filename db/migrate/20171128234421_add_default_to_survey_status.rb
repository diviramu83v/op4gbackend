# frozen_string_literal: true

class AddDefaultToSurveyStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_statuses, :default, :boolean, null: false, default: false
  end
end
