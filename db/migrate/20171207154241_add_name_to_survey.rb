# frozen_string_literal: true

class AddNameToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :name, :string
  end
end
