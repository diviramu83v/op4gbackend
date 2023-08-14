# frozen_string_literal: true

class AddTokenToSurveyResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_responses, :token, :string, null: false
    add_index :survey_responses, :token, unique: true
  end
end
