# frozen_string_literal: true

class AddSurveyToOnramp < ActiveRecord::Migration[5.2]
  def change
    add_reference :onramps, :survey, foreign_key: true
  end
end
