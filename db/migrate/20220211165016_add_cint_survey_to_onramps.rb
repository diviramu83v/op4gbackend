# frozen_string_literal: true

class AddCintSurveyToOnramps < ActiveRecord::Migration[5.2]
  def change
    add_reference :onramps, :cint_survey, foreign_key: true
  end
end
