# frozen_string_literal: true

class AddCategoryToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :category, :string
  end
end
