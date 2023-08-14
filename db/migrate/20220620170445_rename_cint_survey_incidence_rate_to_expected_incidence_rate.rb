# frozen_string_literal: true

class RenameCintSurveyIncidenceRateToExpectedIncidenceRate < ActiveRecord::Migration[6.1]
  def change
    rename_column :cint_surveys, :incidence_rate, :expected_incidence_rate
  end
end
