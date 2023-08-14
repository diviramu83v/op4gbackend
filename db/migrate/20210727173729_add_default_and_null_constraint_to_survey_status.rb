# frozen_string_literal: true

class AddDefaultAndNullConstraintToSurveyStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_default :surveys, :status, from: nil, to: 'draft'
    change_column_null :surveys, :status, false
  end
end
