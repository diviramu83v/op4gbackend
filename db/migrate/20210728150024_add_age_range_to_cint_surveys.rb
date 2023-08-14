# frozen_string_literal: true

class AddAgeRangeToCintSurveys < ActiveRecord::Migration[5.2]
  def change
    change_table :cint_surveys, bulk: true do |t|
      t.integer :min_age
      t.integer :max_age
    end
  end
end
