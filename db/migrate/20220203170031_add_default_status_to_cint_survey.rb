# frozen_string_literal: true

class AddDefaultStatusToCintSurvey < ActiveRecord::Migration[5.2]
  def change
    change_column_default :cint_surveys, :status, from: 'live', to: 'draft'
  end
end
