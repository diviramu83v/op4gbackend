# frozen_string_literal: true

class AddPostalCodesToCintSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :cint_surveys, :postal_codes, :text
  end
end
