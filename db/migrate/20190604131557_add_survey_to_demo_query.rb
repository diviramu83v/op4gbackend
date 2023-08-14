# frozen_string_literal: true

class AddSurveyToDemoQuery < ActiveRecord::Migration[5.1]
  def change
    add_reference :demo_queries, :survey, foreign_key: true
  end
end
