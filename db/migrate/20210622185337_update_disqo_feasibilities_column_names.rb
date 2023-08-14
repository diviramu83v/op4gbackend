# frozen_string_literal: true

# this updates the misnamed Disqo Feasibilities column names
class UpdateDisqoFeasibilitiesColumnNames < ActiveRecord::Migration[5.2]
  def change
    change_table :disqo_feasibilities do |t|
      t.rename :daysInField, :days_in_field
      t.rename :incidenceRate, :incidence_rate
    end
  end
end
