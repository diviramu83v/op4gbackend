# frozen_string_literal: true

class MoveSurveyFromProjectToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_reference :surveys, :campaign, null: false, foreign_key: true
    remove_column :surveys, :project_id, :integer
  end
end
