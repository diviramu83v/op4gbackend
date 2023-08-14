# frozen_string_literal: true

class SetCategoryToNullFalseOnSurveys < ActiveRecord::Migration[5.2]
  def change
    change_column_null :surveys, :category, false
  end
end
