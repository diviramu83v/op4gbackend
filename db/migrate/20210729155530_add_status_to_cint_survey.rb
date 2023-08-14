# frozen_string_literal: true

class AddStatusToCintSurvey < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :cint_surveys, :status, :string, null: false, default: 'live'
  end
end
