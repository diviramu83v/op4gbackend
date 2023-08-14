# frozen_string_literal: true

class AddLanguageToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :language, :string
  end
end
