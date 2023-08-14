# frozen_string_literal: true

class AddSurveyToKeys < ActiveRecord::Migration[5.1]
  def change
    add_reference :keys, :survey, foreign_key: true
  end
end
