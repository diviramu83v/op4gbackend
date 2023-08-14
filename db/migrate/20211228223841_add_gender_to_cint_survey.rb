# frozen_string_literal: true

class AddGenderToCintSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :cint_surveys, :gender, :string
  end
end
