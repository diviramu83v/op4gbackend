# frozen_string_literal: true

class AddCountryToSurvey < ActiveRecord::Migration[6.1]
  def change
    add_reference :surveys, :country, foreign_key: true
  end
end
