# frozen_string_literal: true

class AddNameToCintSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :cint_surveys, :name, :string
  end
end
